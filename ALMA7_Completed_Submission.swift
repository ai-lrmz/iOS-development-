

typealias Reading = (sensor: String, value: Int)

func splitOnce(_ line: String, by separator: Character) -> (String, String)? {
    guard let index = line.firstIndex(of: separator) else { return nil }
    let left = String(line[..<index])
    let right = String(line[line.index(after: index)...])
    return (left, right)
}

let rawLog = [
    "O2:87", "TEMP:-12", "O2:9x", "PRESS:101", "TEMP:abc", "O2:",
    "RAD:3", "O2:64", ":55", "TEMP:31", "PRESS:98", "O2:71",
    "RAD:-1", "TEMP:4", "PRESS:1o2", "O2:90"
]

class Tank {
    var level: Int
    init(level: Int) { self.level = level }
}

class Module {
    let name: String
    var oxygenTank: Tank?
    init(name: String, oxygenTank: Tank?) {
        self.name = name
        self.oxygenTank = oxygenTank
    }
}

class CrewMember {
    let name: String
    let role: String
    let priority: Int
    var module: Module?
    init(name: String, role: String, priority: Int, module: Module?) {
        self.name = name
        self.role = role
        self.priority = priority
        self.module = module
    }
}

let lab  = Module(name: "Lab",  oxygenTank: Tank(level: 40))
let hab  = Module(name: "Hab",  oxygenTank: Tank(level: 12))
let dock = Module(name: "Dock", oxygenTank: nil)

let crew = [
    CrewMember(name: "Timur",   role: "Engineer",  priority: 3, module: lab),
    CrewMember(name: "Dana",    role: "Scientist", priority: 4, module: dock),
    CrewMember(name: "Aigerim", role: "Commander", priority: 1, module: hab),
    CrewMember(name: "Nurlan",  role: "Pilot",     priority: 2, module: nil)
]

var roster: [String: CrewMember] = [:]
for member in crew { roster[member.name] = member }

print("ALMA-7 systems online: \(rawLog.count) log lines, \(crew.count) crew members.")

// MARK: Level 1 · Decoding Telemetry

func parseReading(_ raw: String) -> Reading? {
    guard let parts = splitOnce(raw, by: ":"),
          parts.0.isEmpty == false,
          let value = Int(parts.1),
          value >= 0 || parts.0 == "TEMP"
    else {
        return nil
    }

    return (sensor: parts.0, value: value)
}

func parseLog(_ lines: [String]) -> (valid: [Reading], invalidCount: Int) {
    var valid: [Reading] = []
    var invalidCount = 0

    for line in lines {
        guard let reading = parseReading(line) else {
            invalidCount += 1
            continue
        }
        valid.append(reading)
    }

    return (valid: valid, invalidCount: invalidCount)
}

let A = parseLog(rawLog).invalidCount

print("\nLEVEL 1")
print(parseReading("O2:87") as Any)
print(parseReading("TEMP:-12") as Any)
print(parseReading("RAD:-1") as Any)
print(parseReading(":55") as Any)
print("A =", A)

// MARK: Level 2 · Analysis

func select(_ readings: [Reading], where isIncluded: (Reading) -> Bool) -> [Reading] {
    var result: [Reading] = []

    for reading in readings {
        if isIncluded(reading) {
            result.append(reading)
        }
    }

    return result
}

func values(of readings: [Reading]) -> [Int] {
    var result: [Int] = []

    for reading in readings {
        result.append(reading.value)
    }

    return result
}

func stats(of values: [Int]) -> (min: Int, max: Int, average: Double)? {
    guard let first = values.first else {
        return nil
    }

    var minValue = first
    var maxValue = first
    var total = first

    for value in values.dropFirst() {
        if value < minValue {
            minValue = value
        }
        if value > maxValue {
            maxValue = value
        }
        total += value
    }

    return (min: minValue, max: maxValue, average: Double(total) / Double(values.count))
}

func stats(_ values: Int...) -> (min: Int, max: Int, average: Double)? {
    stats(of: values)
}

let parsed = parseLog(rawLog).valid
let o2Readings = select(parsed) { $0.sensor == "O2" }
let o2Values = values(of: o2Readings)
let o2Stats = stats(of: o2Values)
let B = Int(o2Stats?.average ?? 0)

print("\nLEVEL 2")
print("O2 readings:", o2Readings)
print("O2 values:", o2Values)
print("stats:", o2Stats as Any)
print("stats(3, 8, 1):", stats(3, 8, 1) as Any)
print("stats():", stats() as Any)
print("B =", B)

// MARK: Level 2.3 · Closure Ladder

let sorted1 = parsed.sorted(by: { (first: Reading, second: Reading) -> Bool in
    return first.value > second.value
})

let sorted2 = parsed.sorted(by: { (first, second) in
    return first.value > second.value
})

let sorted3 = parsed.sorted(by: { first, second in
    first.value > second.value
})

let sorted4 = parsed.sorted(by: { $0.value > $1.value })

let sorted5 = parsed.sorted { $0.value > $1.value }

var allSortsMatch = sorted1.count == sorted2.count &&
    sorted2.count == sorted3.count &&
    sorted3.count == sorted4.count &&
    sorted4.count == sorted5.count

if allSortsMatch {
    for index in 0..<sorted1.count {
        if sorted1[index].sensor != sorted2[index].sensor || sorted1[index].value != sorted2[index].value ||
           sorted2[index].sensor != sorted3[index].sensor || sorted2[index].value != sorted3[index].value ||
           sorted3[index].sensor != sorted4[index].sensor || sorted3[index].value != sorted4[index].value ||
           sorted4[index].sensor != sorted5[index].sensor || sorted4[index].value != sorted5[index].value {
            allSortsMatch = false
            break
        }
    }
}
print("All five sorting results match:", allSortsMatch)

// MARK: Level 3 · Temperature Stabilization

func heatUp(_ t: Int) -> Int {
    t + 5
}

func coolDown(_ t: Int) -> Int {
    t - 3
}

func hold(_ t: Int) -> Int {
    t
}

func chooseProtocol(for temp: Int) -> (Int) -> Int {
    if temp < 18 {
        return heatUp
    } else if temp > 24 {
        return coolDown
    } else {
        return hold
    }
}

func runUntilStable(from start: Int, maxSteps: Int = 10) -> (finalTemp: Int, steps: Int, isStable: Bool) {
    var temperature = start
    var steps = 0

    while (temperature < 18 || temperature > 24) && steps < maxSteps {
        let selectedProtocol = chooseProtocol(for: temperature)
        temperature = selectedProtocol(temperature)
        steps += 1
    }

    return (finalTemp: temperature, steps: steps, isStable: temperature >= 18 && temperature <= 24)
}

let lowestTemperature = stats(of: values(of: select(parsed) { $0.sensor == "TEMP" }))?.min ?? 0
let C = runUntilStable(from: lowestTemperature).steps

print("\nLEVEL 3")
print("heatUp(10):", heatUp(10))
print("heatUp(20):", heatUp(20))
print("coolDown(30):", coolDown(30))
print("coolDown(20):", coolDown(20))
print("hold(20):", hold(20))
print("hold(22):", hold(22))
print("runUntilStable(from: 31):", runUntilStable(from: 31))
print("runUntilStable(from: -100, maxSteps: 5):", runUntilStable(from: -100, maxSteps: 5))
print("C =", C)

// MARK: Level 4 · The Crew

func oxygenLevel(of member: CrewMember) -> Int? {
    member.module?.oxygenTank?.level
}

func status(of member: CrewMember) -> String {
    guard let module = member.module else {
        return "\(member.name): no data (open space)"
    }

    guard let oxygen = oxygenLevel(of: member) else {
        return "\(member.name): no data (\(module.name))"
    }

    return oxygen < 20
        ? "\(member.name): \(oxygen)% CRITICAL"
        : "\(member.name): \(oxygen)% OK"
}

@discardableResult
func transferOxygen(from source: inout Int, to target: inout Int, amount: Int) -> Int {
    guard amount > 0 else {
        return 0
    }

    let transferable = min(amount, source, 100 - target)
    guard transferable > 0 else {
        return 0
    }

    source -= transferable
    target += transferable

    return transferable
}

let transferred = transferOxygen(from: &lab.oxygenTank!.level, to: &hab.oxygenTank!.level, amount: 30)
let D = hab.oxygenTank?.level ?? 0

print("\nLEVEL 4")
for member in crew {
    print(status(of: member))
}
print("Transferred:", transferred)
print("D =", D)

func evacuationOrder(_ names: String..., roster: [String: CrewMember]) -> [String] {
    var found: [CrewMember] = []

    for name in names {
        guard let member = roster[name] else {
            print("Unknown crew member: \(name)")
            continue
        }
        found.append(member)
    }

    found.sort { $0.priority < $1.priority }

    var result: [String] = []
    for member in found {
        result.append(member.name)
    }

    return result
}

print(evacuationOrder("Dana", "Ghost", "Aigerim", "Timur", roster: roster))



func reportOxygen(for member: CrewMember) -> String {
    guard let oxygen = oxygenLevel(of: member) else {
        return "\(member.name): no data"
    }

    return "\(member.name): \(oxygen)%"
}

func firstCritical(in crew: [CrewMember]) -> String? {
    for member in crew {
        guard let oxygen = oxygenLevel(of: member) else {
            continue
        }

        if oxygen < 20 {
            return member.name
        }
    }

    return nil
}

print("\nLEVEL 5")
print(reportOxygen(for: crew[0]))
print(reportOxygen(for: crew[1]))
print(reportOxygen(for: crew[3]))

let firstCriticalTestCrew = [
    CrewMember(name: "First", role: "Test", priority: 1, module: Module(name: "FirstModule", oxygenTank: Tank(level: 10))),
    CrewMember(name: "Second", role: "Test", priority: 2, module: Module(name: "SecondModule", oxygenTank: Tank(level: 5)))
]

let firstCriticalTest = firstCritical(in: firstCriticalTestCrew)
print("firstCritical test:", firstCriticalTest as Any)
// Expected: Optional("First"), proving the function returns the FIRST critical member.

// MARK: Finale · Launch Code

let launchCode = "\(A)-\(B)-\(C)-\(D)"
print("\nLAUNCH CODE: \(launchCode)")

// MARK: Bonus

func makeAlarm(threshold: Int) -> (Int) -> Bool {
    var count = 0

    return { oxygen in
        if oxygen < threshold {
            count += 1
            print("Alarm #\(count)")
            return true
        }
        return false
    }
}

let alarm = makeAlarm(threshold: 20)
print("Alarm test:", alarm(12))
print("Alarm test:", alarm(40))
print("Alarm test:", alarm(5))



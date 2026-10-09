// =============================================================
//  Station ALMA-7, Part III: The Repair Fleet
//  iOS Mobile Development · Module 5 · Lab Assignment
// =============================================================

import Foundation

// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

let fleetData: [(kind: String, id: String, charge: Int)] = [
    (kind: "welder",  id: "W-1", charge: 80),
    (kind: "scanner", id: "S-1", charge: 45),
    (kind: "cargo",   id: "C-1", charge: 100),
    (kind: "welder",  id: "W-2", charge: 15),
    (kind: "scanner", id: "S-2", charge: 60),
    (kind: "tug",     id: "T-1", charge: 50)
]

let sensorData: [(id: String, charge: Int)] = [
    (id: "hull-cam", charge: 12),
    (id: "thermal",  charge: 77)
]

struct LegacyBeacon {
    let name: String
    let signalStrength: Int
}

let beacon = LegacyBeacon(name: "ALMA-BEACON", signalStrength: 8)

print("Fleet registry online: \(fleetData.count) drone records, \(sensorData.count) sensors, beacon \(beacon.name).")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================

// MARK: Level 1 · The Power Cell

// Why a class and not a struct here?  ->
// PowerCell is a class because multiple drones need to share and mutate the exact same power source.

final class PowerCell {
    private var charge: Int

    init(charge: Int) {
        if charge < 0 {
            self.charge = 0
        } else if charge > 100 {
            self.charge = 100
        } else {
            self.charge = charge
        }
    }

    func level() -> Int {
        return charge
    }

    func spend(amount: Int) -> Bool {
        if amount <= 0 || charge < amount {
            return false
        }
        charge -= amount
        return true
    }

    func recharge(by amount: Int) {
        if amount <= 0 { return }
        charge += amount
        if charge > 100 {
            charge = 100
        }
    }
}

// Encapsulation proof:
// let testCell = PowerCell(charge: 100)
// testCell.charge = 100
// error: 'charge' is inaccessible due to 'private' protection level


// MARK: Level 2 · The Fleet

// 2.1  What does `final` on runOnce() buy you?  ->
// Making runOnce() final ensures subclasses cannot override or break the main execution logic.

class Drone {
    let id: String
    let cell: PowerCell

    init(id: String, cell: PowerCell) {
        self.id = id
        self.cell = cell
    }

    var powerCost: Int { 10 }

    var statusLine: String {
        return "\(id): \(cell.level().powerBar)"
    }

    func performTask() -> Int {
        return 0
    }

    final func runOnce() -> Int {
        if !cell.spend(amount: powerCost) {
            return 0
        }
        return performTask()
    }
}

// 2.2
final class WelderDrone: Drone {
    override var powerCost: Int { 25 }

    override func performTask() -> Int {
        return 40
    }

    func weldSeam() -> String {
        return "Seam welded by \(id)"
    }
}

class ScannerDrone: Drone {
    override var powerCost: Int { 10 }

    override func performTask() -> Int {
        return 15
    }

    override var statusLine: String {
        return super.statusLine + " [scanner]"
    }
}

final class CargoDrone: Drone {
    override var powerCost: Int { 20 }

    override func performTask() -> Int {
        return 25
    }
}

// 2.3
func makeDrone(kind: String, id: String, charge: Int) -> Drone? {
    let cell = PowerCell(charge: charge)
    if kind == "welder" {
        return WelderDrone(id: id, cell: cell)
    } else if kind == "scanner" {
        return ScannerDrone(id: id, cell: cell)
    } else if kind == "cargo" {
        return CargoDrone(id: id, cell: cell)
    } else {
        return nil
    }
}

var fleet: [Drone] = []
for item in fleetData {
    if let drone = makeDrone(kind: item.kind, id: item.id, charge: item.charge) {
        fleet.append(drone)
    } else {
        print("Skipped unknown drone type: \(item.kind)")
    }
}


// MARK: Level 3 · The Shift

func runShift(_ fleet: [Drone], rounds: Int) -> Int {
    var totalWork = 0
    for _ in 0..<rounds {
        for drone in fleet {
            totalWork += drone.runOnce()
        }
    }
    return totalWork
}

let A = runShift(fleet, rounds: 3)

for drone in fleet {
    print(drone.statusLine)
}

var totalChargeLeft = 0
var readyDronesCount = 0

for drone in fleet {
    totalChargeLeft += drone.cell.level()
    if drone.cell.level() >= drone.powerCost {
        readyDronesCount += 1
    }
}

let B = totalChargeLeft
let C = readyDronesCount

print("Drones that can still work: \(C)")


// MARK: Level 4 · Diagnostics

// 4.1
protocol Diagnosable {
    var componentID: String { get }
    var statusCode: Int { get }
    func diagnose() -> String
}

// 4.2
protocol Rechargeable {
    mutating func recharge(by amount: Int)
}

// Why does Drone implement recharge(by:) without `mutating`?  ->
// Drone is a class (reference type), so mutating its properties doesn't change the reference itself.

extension Drone: Diagnosable, Rechargeable {
    var componentID: String { id }

    var statusCode: Int {
        return calculateStatusCode(charge: cell.level())
    }

    func recharge(by amount: Int) {
        cell.recharge(by: amount)
    }
}

struct SensorModule: Diagnosable, Rechargeable {
    let id: String
    var chargeLevel: Int

    var componentID: String { id }

    var statusCode: Int {
        return calculateStatusCode(charge: chargeLevel)
    }

    mutating func recharge(by amount: Int) {
        if amount <= 0 { return }
        chargeLevel += amount
        if chargeLevel > 100 {
            chargeLevel = 100
        }
    }
}

// 4.3
// Why could [Drone] never have held the sensors?  ->
// [Drone] can only store instances of Drone or its subclasses, but SensorModule is a struct.

func diagnosticsReport(_ components: [Diagnosable]) -> String {
    var result = ""
    for i in 0..<components.count {
        result += components[i].diagnose()
        if i < components.count - 1 {
            result += "\n"
        }
    }
    return result
}


// MARK: Level 5 · Shared Behaviour

// 5.1 · default diagnose() + Health Rule
extension Diagnosable {
    func diagnose() -> String {
        return "\(componentID): code \(statusCode)"
    }

    func calculateStatusCode(charge: Int) -> Int {
        if charge < 20 {
            return 2
        } else if charge <= 49 {
            return 1
        } else {
            return 0
        }
    }
}

// 5.2 · LegacyBeacon
extension LegacyBeacon: Diagnosable {
    var componentID: String { name }

    var statusCode: Int {
        return calculateStatusCode(charge: signalStrength)
    }

    func diagnose() -> String {
        return "[BEACON] \(name): code \(statusCode)"
    }
}

var sensors: [SensorModule] = []
for s in sensorData {
    sensors.append(SensorModule(id: s.id, chargeLevel: s.charge))
}

var allComponents: [Diagnosable] = []
for drone in fleet {
    allComponents.append(drone)
}
for sensor in sensors {
    allComponents.append(sensor)
}
allComponents.append(beacon)

print("\n--- DIAGNOSTICS REPORT ---")
print(diagnosticsReport(allComponents))

var statusSum = 0
for comp in allComponents {
    statusSum += comp.statusCode
}

let D = statusSum

// 5.3
extension Int {
    var powerBar: String {
        var val = self
        if val < 0 { val = 0 }
        if val > 100 { val = 100 }

        let hashes = val / 10
        let dots = 10 - hashes

        var bar = ""
        for _ in 0..<hashes {
            bar += "#"
        }
        for _ in 0..<dots {
            bar += "."
        }
        return bar
    }
}


// MARK: Level 6 · Incident Reports

/*
Report 1:
- Expectation: Author wanted performTask() to override base method and return 30.
- Actual: Doesn't override because 'override' keyword is missing. Returns 0.
- Language Rule: Overriding a superclass method in Swift requires the 'override' keyword.
- Fix: Add 'override' before func performTask().

Report 2:
- Expectation: Author wanted HeavyWelder to override runOnce() and return 999.
- Actual: Compiler error: Cannot override final method.
- Language Rule: Methods marked with 'final' in a class cannot be overridden by subclasses.
- Fix: Override performTask() instead of runOnce().

Report 3:
- Expectation: Author tried to call weldSeam() on the first drone.
- Actual: Compiler error: Value of type 'Drone' has no member 'weldSeam'.
- Language Rule: The array type is [Drone], so only Drone methods are visible without downcasting.
- Fix:
  if let welder = reportFleet[0] as? WelderDrone {
      print(welder.weldSeam())
  }
- Why as? returns optional: Downcasting can fail if the item is not actually a WelderDrone.

Report 4:
- Expectation: Author expected "thruster T-1" to be printed.
- Actual: Prints "generic component".
- Language Rule: label() was defined in the extension but not declared in the protocol itself, so static dispatch is used.
- Fix: Add 'func label() -> String' inside the protocol Labelled definition.
*/


// MARK: Finale · Mission Code

let missionCode = "\(A)-\(B)-\(C)-\(D)"
print("\nMISSION CODE: \(missionCode)")


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. Why does a class satisfy a `mutating` protocol requirement without the
    keyword, while a struct must write it?
    
    Classes are reference types, so changing their properties doesn't mutate the reference itself.
    Structs are value types, so modifying properties mutates the value, requiring 'mutating'.

 2. One thing inheritance does that protocols cannot, and one thing
    protocols do that inheritance cannot:
    
    - Inheritance lets subclasses share stored properties and logic directly from a base class.
    - Protocols allow completely different types (both structs and classes) to share the same interface.

 3. What does `final` prevent, and what did it protect in runOnce()?
    
    'final' prevents methods from being overridden by subclasses.
    It protected runOnce() so subclasses cannot bypass or change the power check ritual.

 4. In Report 4, why did the protocol extension's method win?
    
    Because label() was not listed in the protocol declaration. When a method exists only in an extension, static dispatch calls the extension's default version when used through the protocol type.
*/
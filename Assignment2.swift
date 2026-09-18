import Foundation



// Task 1

var fruits = ["apple", "banana", "orange", "mango", "grape"]

print("Task 1:")
print("Third fruit: \(fruits[2])")



// Task 2

var favoriteNumbers: Set<Int> = [7, 10, 21, 42]

favoriteNumbers.insert(100)

print("\nTask 2:")
print("Updated favorite numbers:\(favoriteNumbers)")


// Task 3

var programmingLanguages: [String: Int] = [
    "Python": 1991,
    "Java": 1995,
    "Swift": 2014
]

print("\nTask 3:")
print("Swift was released in \(programmingLanguages["Swift"]!)")


// Task 4

var colors = ["red", "blue", "green", "yellow"]

colors[1] = "purple"

print("\nTask 4:")
print("Updated colors: \(colors)")


// Task 5

let firstSet: Set<Int> = [1, 2, 3, 4]
let secondSet: Set<Int> = [3, 4, 5, 6]

let intersectionSet = firstSet.intersection(secondSet)

print("\nTask 5:")
print("Intersection: \(intersectionSet)")


// Task 6

var studentScores: [String: Int] = [
    "Aida": 90,
    "Ali": 85,
    "Dana": 95
]

studentScores.updateValue(98, forKey: "Aida")

print("\nTask 6:")
print("Updated student scores: \(studentScores)")


// Task 7

let firstFruits = ["apple", "banana"]
let secondFruits = ["cherry", "date"]

let mergedFruits = firstFruits + secondFruits

print("\nTask 7:")
print("Merged fruits: \(mergedFruits)")



// Task 8

var countryPopulations: [String: Int] = [
    "Kazakhstan": 20_000_000,
    "USA": 340_000_000,
    "Japan": 123_000_000
]

countryPopulations["Canada"] = 40_000_000

print("\nTask 8:")
print("Updated country populations: \(countryPopulations)")


// Task 9

let animals1: Set<String> = ["cat", "dog"]
let animals2: Set<String> = ["dog", "mouse"]

let unionAnimals = animals1.union(animals2)
let finalAnimals = unionAnimals.subtracting(animals2)

print("\nTask 9:")
print("Final set: \(finalAnimals)")


// Task 10

let studentGrades: [String: [Int]] = [
    "Aida": [90, 95, 88],
    "Ali": [85, 91, 87],
    "Dana": [92, 89, 96]
]

print("\nTask 10:")
print("Aida's second grade: \(studentGrades["Aida"]![1])")
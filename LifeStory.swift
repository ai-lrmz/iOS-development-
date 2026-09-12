import Foundation

var firstName: String = "Aida"
var lastName: String = "Ramazanova"
var birthYear: Int = 2006
var isStudent: Bool = true
var height: Double = 1.65

let currentYear: Int = 2026
let age: Int = currentYear - birthYear

var hobby: String = "drawing"
var numberOfHobbies: Int = 4
var favoriteNumber: Int = 7
var isHobbyCreative: Bool = true

var favoriteColor: String = "purple"
var futureGoals: String = "become a professional iOS developer"
var favoriteEmoji: String = "🌸"

let lifeStory = """
My name is \(firstName) \(lastName).
I am \(age) years old, born in \(birthYear).
I am currently a student: \(isStudent).
My height is \(height) meters.
My favorite color is \(favoriteColor).
I enjoy \(hobby), which is a creative hobby: \(isHobbyCreative).
I have \(numberOfHobbies) hobbies in total.
My favorite number is \(favoriteNumber).
My favorite emoji is \(favoriteEmoji).
In the future, I want to \(futureGoals).
"""

print(lifeStory)
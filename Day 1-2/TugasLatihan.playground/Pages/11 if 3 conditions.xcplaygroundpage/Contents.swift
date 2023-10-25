//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)
// If the student’s exam score was over 80 then print a success message.
let studentScore = 95

if studentScore > 80 {
    print("You passed the exam")
} else {
    print("You failed")
}

// If the user entered a name that comes after their friend’s name alphabetically, put the friend’s name first.
let userName = "Wagner"
let friendName = "Charles"

if userName < friendName {
    print("\(userName) then \(friendName)")
} else {
    print("\(friendName) then \(userName)")
}

// If adding a number to an array makes it contain more than 3 items, remove the oldest one.
var number = [5, 9, 90, 88]
number.append(8)
number.append(3)
for numbers in number{
    if number.count > 3{
        number.removeFirst()
    }
}
print(number)

// If the user was asked to enter their name and typed nothing at all, give them a default name of “Anonymous”.

var username = "Mweh"
username = ""

if username.isEmpty == true{
    username = "Anonymous"
}
print(username)


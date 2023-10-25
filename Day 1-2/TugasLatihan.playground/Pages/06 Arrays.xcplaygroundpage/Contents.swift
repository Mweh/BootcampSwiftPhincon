//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)

// Stores multiple data in one variable
// Only one type of data can be allowed
// array's index start at 0
// duplicate allowed

var anime = [String]()
anime.append("Naruto")
anime.append("Dragon Ball")

print(anime.count)
print(anime)

var ChakraElement = Array<String>()
ChakraElement.append("Fire")
print(ChakraElement)

let rating = [1, 8, 4, 9, 3]
print(rating.sorted())
print(rating.reversed())

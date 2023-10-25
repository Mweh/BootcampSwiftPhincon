//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)

var zeros = "It's over 9000"

for _ in 1...10{ // 1-10
    zeros += "0"
}
print("\(zeros)!")

var dice = 0

while dice != 12 {
    dice = Int.random(in: 1...12)
    print("I rolled \(dice)")
}
print("You hit highest dice!")

// 1..<10 1-9
// 1... ...10

for i in 1...10{
    for j in 1...5{
        print("i: \(i)")
    }
}

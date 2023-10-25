//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)

for i in 1...100{
    if i.isMultiple(of: 15) == true{
        print("FizzBuzz")
        continue
    } else if i.isMultiple(of: 5) == true {
        print("Buzz")
        continue
    } else if i.isMultiple(of: 3) == true {
        print("Fizz")
        continue
    }
    print(i)
}

/*
 The problem is called fizz buzz, and has been used in job interviews, university entrance tests, and more for as long as I can remember. Your goal is to loop from 1 through 100, and for each number:

 If it’s a multiple of 3, print “Fizz”
 If it’s a multiple of 5, print “Buzz”
 If it’s a multiple of 3 and 5, print “FizzBuzz”
 Otherwise, just print the number.
 */

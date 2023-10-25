//write a function that accepts an integer from 1 through 10,000, and returns the integer square root of that number. That sounds easy, but there are some catches:
//You can’t use Swift’s built-in sqrt() function or similar – you need to find the square root yourself.
//If the number is less than 1 or greater than 10,000 you should throw an “out of bounds” error.
//You should only consider integer square roots – don’t worry about the square root of 3 being 1.732, for example.
//If you can’t find the square root, throw a “no root” error.

enum SquaredError: Error {
    case outOfBounds, noRoot
}


func squaredNumber(number: Int)  throws -> Int {
    var result = 1
    var i = 1
    if number >= 1 && number <= 10_000 {
        for i in 1...number {
            if i*i == number{
                return i
            }           
        } 
        throw SquaredError.noRoot
    } else {
        throw SquaredError.outOfBounds
    }
}

do {
    let square = try squaredNumber(number: 4624)
    print("Square root = \(square)")
   }
catch SquaredError.outOfBounds {
    print("Out of Bounds")
}
catch SquaredError.noRoot {
    print("No Root")
}


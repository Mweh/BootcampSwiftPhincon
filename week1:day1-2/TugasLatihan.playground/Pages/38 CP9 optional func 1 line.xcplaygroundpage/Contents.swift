//
//Your challenge is this: 
//write a function that accepts an optional array of integers, 
//and returns one randomly. 
//If the array is missing or empty, return a random number in the range 1 through 100.
//you should be able to write this whole thing in one line of code.
//
//

func randomNumber (number: [Int]?)-> Int { return  number?.randomElement() ?? Int.random(in: 1...100) }

print(randomNumber(number: nil))
print(randomNumber(number: [3, 9, 1, 5]))



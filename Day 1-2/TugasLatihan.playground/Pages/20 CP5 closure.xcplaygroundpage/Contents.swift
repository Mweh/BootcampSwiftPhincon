//With closures under your belt, it’s time to try a little coding challenge using them.
//
//You’ve already met sorted(), filter(), map(), so I’d like you to put them together in a chain – call one, then the other, then the other back to back without using temporary variables.
//
//Your input is this:
//
//let luckyNumbers = [7, 4, 38, 21, 16, 15, 12, 33, 31, 49]
//Your job is to:
//
//Filter out any numbers that are even
//Sort the array in ascending order
//Map them to strings in the format “7 is a lucky number”
//Print the resulting array, one item per line

//import Cocoa

let luckyNumbers = [7, 4, 38, 21, 16, 15, 12, 33, 31, 49]

let solve = {(whatNumber: [Int]) in
    whatNumber.sorted()
        .filter{ !$0.isMultiple(of: 2) }
        .map{ print("\($0) is a lucky number") }
}

solve(luckyNumbers)

//print("Numbers = \(luckyNumbers)")
//
//let sortedNumbers = luckyNumbers.sorted {( $0 < $1) }
//print("Numbers after sorted = \(sortedNumbers)")
//
//let oddNumbers = sortedNumbers.filter { !$0.isMultiple(of: 2) }
//print("Odd Numbers = \(oddNumbers)")
//print()
//
//let mapNumbers = oddNumbers.map { print("\($0) is a lucky number") }



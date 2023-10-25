//: [Previous](@previous)
// draw a yugioh card monster, random stars, 1-4 only summon w/o sacrifice needed
import Cocoa
func checkLetter(string1: String, string2: String) -> Bool{
    let check: Bool
    if string1.sorted() == string2.sorted(){
        check = true
    } else {
        check = false
    }
    return check
    print(check)
}

let check1 = checkLetter(string1: "abc", string2: "bca")

print(check1)

func pythagoras(a: Double, b: Double) -> Double{
    sqrt((a*a)+(b*b))
}

print(pythagoras(a: 3, b: 4))

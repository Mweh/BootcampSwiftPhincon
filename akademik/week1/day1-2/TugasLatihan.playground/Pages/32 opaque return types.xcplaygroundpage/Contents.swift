import Cocoa
// opaque return types
// when u dont know what return gonna be in the future, use opaque return types, so you can change it later
// opaque return types syntax: "-> some Equatable"

protocol  View { }


func randomNumber() -> some Equatable { // cant use without some
    //cause with some, you know it specific
    Int.random(in: 1...2) // swift behind the scene knows what return type is which is Int
}

print(randomNumber() == randomNumber())

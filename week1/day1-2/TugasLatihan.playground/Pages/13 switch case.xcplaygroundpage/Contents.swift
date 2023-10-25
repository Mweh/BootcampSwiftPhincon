//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)

enum narutoJutsu: String {
    case rasengan, kageBunshin, talkNoJutsu, sanninMode, nineTails, sleepNoJutsu
    func print() -> String {
        switch self{
        case .sanninMode:
            return "Pain can be defeated"
        case .nineTails:
            return "Pain can be defeated"
        case .kageBunshin:
            return "Needs transformation, else pain will win"
        case .rasengan:
            return "Needs transformation, else pain will win"
        case .talkNoJutsu:
            return "You can't win by talk non sense"
        default:
            return "Pain win"
        }
    }
}

var narutoJutsus = narutoJutsu.rasengan

print(narutoJutsus.print()
)


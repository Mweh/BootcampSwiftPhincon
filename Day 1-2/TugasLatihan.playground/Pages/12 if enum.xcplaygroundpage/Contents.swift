//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)

enum narutoJutsu {
    case rasengan, kageBunshin, talkNoJutsu, sanninMode, nineTails, sleepNoJutsu
}

let narutoJutsus = narutoJutsu.kageBunshin

if narutoJutsus == .sanninMode || narutoJutsus == .nineTails {
    print("Pain can be defeated")
} else if narutoJutsus == .kageBunshin || narutoJutsus == .rasengan {
    print("Needs transformation, else pain will win")
} else if narutoJutsus == .talkNoJutsu {
    print("You can't win by talk non sense")
} else {
    print("Pain win")
}


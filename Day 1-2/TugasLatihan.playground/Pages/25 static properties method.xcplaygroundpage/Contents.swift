
// regular properties inside struct can be used in static method inside struct
// static means they dont have instances, we directly call them by struct's name
// instances means we create variable for our struct
// self with s lowercase means our struct value 
// Self with S uppercase means our struct type 

import Cocoa

let akatsukiMember = ["Tobi", "Pain", "Nagato", "Konan", "Deidara", "Sasori", "Itachi", "Kisame", "Hidan", "Kakuzu", "Zetsu"] 

struct Akatsuki{
    static var member: Int = akatsukiMember.count // static properties
    var memberDead: Int
    var leader: String
    var currentLeader: String
    
    init(member: Int) { // custom initializers
        Self.member = member
        memberDead = 0
        leader = "Pain"
        currentLeader = ""
    }
    
    static func info() -> String { 
        return "Currently, Akatsuki member is \(member)"
    }
}

var gaaraKazekageArc = Akatsuki(member: akatsukiMember.count)
print(gaaraKazekageArc.leader)

print(Akatsuki.info()) // directly calls them without instances
print(Akatsuki.member)

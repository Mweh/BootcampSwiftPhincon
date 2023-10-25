
// property observer = didSet(best practice, used a lot), willSet

import Cocoa

let akatsukiMember = ["Tobi", "Pain", "Nagato", "Konan", "Deidara", "Sasori", "Itachi", "Kisame", "Hidan", "Kakuzu", "Zetsu"] 

struct Akatsuki{
    var member = akatsukiMember.count
    var memberDead: Int
    var leader: String
    var currentLeader: String
    
    var memberLeft: Int { // property dynamically 
        get {
            member - memberDead
        }
        set {
//            member = memberDead + newValue
            memberDead = member - newValue
        }
    } 
    

        
    var leaderInfo: String {
        didSet{ // didSet is property observer means that every time its value changed, you run code inside
            print("There was \(oldValue) as the leader of the Akatsuki but as for now the leader changed to \(leaderInfo)")
            print()
        }
    }
    
    func info() -> String { 
        return "Currently, Akatsuki member is \(memberLeft)\nSo the last leader is \(leaderInfo)"
    }
}

// if u want the init stays while you can use custom init , create extension

extension Akatsuki{
    init(member: Int){ // custom initializers
        self.member = member
        self.memberDead = 0
        leader = "No One"
        currentLeader = ""
        leaderInfo = leader
    }
}

var gaaraKazekageArc = Akatsuki(member: 14)
gaaraKazekageArc.leaderInfo = "Pain"
gaaraKazekageArc.leaderInfo = "Nagato"
gaaraKazekageArc.leaderInfo = "Tobi"
gaaraKazekageArc.leaderInfo = "Madara"
gaaraKazekageArc.memberLeft = 12
print(gaaraKazekageArc.info())

print()

var defaultAkatsuki = Akatsuki(member: 14, memberDead: 0,leader: "",currentLeader: "", leaderInfo: "")
print(defaultAkatsuki.memberDead)

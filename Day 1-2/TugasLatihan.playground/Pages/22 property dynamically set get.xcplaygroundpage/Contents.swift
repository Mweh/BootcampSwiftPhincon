
import Cocoa

// computed property is a blend of stored property and method
// property dynamically
// can use set(write) and get(read)

let akatsukiMember = ["Tobi", "Pain", "Nagato", "Konan", "Deidara", "Sasori", "Itachi", "Kisame", "Hidan", "Kakuzu", "Zetsu"] 
struct Akatsuki{
    var member: Int = akatsukiMember.count
    var memberDead = 0
    var leader = "Pain"
    var currentLeader = ""
    
    var memberLeft: Int { // computed property, its value dynamically 
        get {
            member - memberDead
        }
        set {
//            member = memberDead + newValue
            memberDead = member - newValue
        }
    } 
        
    var leaderInfo: String {
        if leader != currentLeader {
            return "\(leader), leader of the Akatsuki is retired and changed to \(currentLeader)"
        } else {
            return "Akatsuki leader \"\(leader)\" is the Strongest"
        }
    }
    
    func info() -> String { 
        return "Currently, Akatsuki member is \(memberLeft)\n\(leaderInfo)"
    }
}

var akatsukiLatest = Akatsuki(leader: "Pain")
akatsukiLatest.currentLeader = "Tobi" // Changing the value of a stored property
akatsukiLatest.memberDead = 11
print(akatsukiLatest.info())
print()

var akatsukiPainArc = Akatsuki(currentLeader: "Pain")
akatsukiPainArc.memberDead = 5
print(akatsukiPainArc.info())
print()

var gaaraKazekageArc = Akatsuki(currentLeader: "Tobi")
gaaraKazekageArc.member = 14
gaaraKazekageArc.memberLeft = 12
print(gaaraKazekageArc.info())


//var akatsukiPainArc = Akatsuki(leader: "Pain")
//akatsukiPainArc.leaderInfo(currentLeader: "Pain")
//akatsukiPainArc.membersLeft(dead: 5)

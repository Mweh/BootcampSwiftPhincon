
import Cocoa

let akatsukiMember = ["Tobi", "Pain", "Nagato", "Konan", "Deidara", "Sasori", "Itachi", "Kisame", "Hidan", "Kakuzu", "Zetsu"] 

struct Akatsuki{
    private var member: Int = akatsukiMember.count //limit access
    private var memberDead: Int
    var leader: String
    private var currentLeader: String
    
    init(member: Int) { // custom initializers
        self.member = member
        memberDead = 0
        leader = "Pain"
        currentLeader = ""
    }

}

var gaaraKazekageArc = Akatsuki(member: akatsukiMember.count)
print(gaaraKazekageArc.leader)

struct Doctor {

    private var currentPatient = "No one"
}
let drJones = Doctor()

struct Office {
    private var passCode: String
    var address: String
    var employees: [String]
    init(address: String, employees: [String]) {
        self.address = address
        self.employees = employees
        self.passCode = "SEKRIT"
    }
}
let monmouthStreet = Office(address: "30 Monmouth St", employees: ["Paul Hudson"])

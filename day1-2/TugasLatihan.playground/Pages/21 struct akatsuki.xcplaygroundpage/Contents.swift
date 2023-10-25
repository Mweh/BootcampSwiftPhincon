// isi property ada String, INt, Array, Enum, methodnya banyak

struct Iphone10Jt {
    let iPhone13: Bool
    let iPhone14: Bool
    let iPhone15: Bool
}

struct IphoneJadul {
    let iPhone4: Bool
    let iPhone5: Bool
    let iPhone6: Bool
}

struct AppleDevices {
    let iphone10Jt: Iphone10Jt
    let iphoneJadul: IphoneJadul
    
    init(iphone10Jt: Iphone10Jt, iphoneJadul: IphoneJadul) {
        self.iphone10Jt = iphone10Jt
        self.iphoneJadul = iphoneJadul
    }
    
    func mahalanMana(iphone10Jt: Int, iphoneJadul: Int) -> String {
        iphone10Jt > iphoneJadul ? "sultan" : "jelatah"
    }
}

var appleDevices = AppleDevices(iphone10Jt: Iphone10Jt(iPhone13: true, iPhone14: false, iPhone15: false), iphoneJadul: IphoneJadul(iPhone4: false, iPhone5: false, iPhone6: false))

print(appleDevices.mahalanMana(iphone10Jt: 0, iphoneJadul: 7_000_000))

let akatsukiMember = ["Tobi", "Pain", "Nagato", "Konan", "Deidara", "Sasori", "Itachi", "Kisame", "Hidan", "Kakuzu", "Zetsu"]

struct Akatsuki{
    var member: Int = akatsukiMember.count
    var leader: String
    
    mutating func membersLeft(dead: Int) {
        member -= dead
        print("Currently, Akatsuki member is \(member)")
    } 
    
     func leaderInfo(currentLeader: String){
        if leader != currentLeader {
            print("\(leader), leader of the Akatsuki is retired and changed to \(currentLeader)")
        } else {
            print("Akatsuki leader \"\(leader)\" is the Strongest")
        }
    }
}

var akatsukiLatest = Akatsuki(leader: "Pain")
akatsukiLatest.leaderInfo(currentLeader: "Tobi")
akatsukiLatest.membersLeft(dead: 11)
print()

var akatsukiPainArc = Akatsuki(leader: "Pain")
akatsukiPainArc.leaderInfo(currentLeader: "Pain")
akatsukiPainArc.membersLeft(dead: 5)



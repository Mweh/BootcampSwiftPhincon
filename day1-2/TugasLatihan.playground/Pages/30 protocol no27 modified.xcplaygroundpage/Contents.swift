protocol Ninja {
    var element: String { get set }
    var uniqueAbilitiy: String { get set }
    func about() -> String
}

class Uchiha: Ninja {
    var element = "Fire"
    var uniqueAbilitiy = "Sharinggan"
    var susanoo: String
    var name: String = "ini 5"{
        didSet{
            "data telah diubah\(name)"
        }
        willSet{
            print("ini willset\(name)")
        }
    }

    init(susanoo: String, name: String){
        self.susanoo = susanoo
        self.name = name
    }

    func about() -> String {
        "All Uchihas have fire as their nature element"
    }
    func susanooColor() {
        print("\(name)'s Susanoo color is \(susanoo)")
    }
}

class Sasuke: Uchiha {
    override init(susanoo: String = "purple", name: String = "Sasuke"){
        super.init(susanoo: susanoo, name: name)
    }
    func jutsu() -> String {
        "\(name) can use \(element) and have \(uniqueAbilitiy)"
    }
}

final class Sarada: Sasuke {
    let otherAbility: String

    init(otherAbility: String){
        self.otherAbility = otherAbility
        super.init(susanoo: "doesnt have", name: "Sarada") // call initializer to parent class
    }

    override func jutsu() -> String { // override means changed the method from their parents
        "\(name) can use \(element) and have \(uniqueAbilitiy), also have \(otherAbility) from their mother"
    }

    override func susanooColor() {
        print("\(name) \(susanoo) Susanoo, yet")
    }
}


final class Kakashi: Uchiha{ // final means this class will not accept inheritance from it but can receive from others
    init(){
        super.init(susanoo: "cyan", name: "Kakashi")
    }
    override func about()-> String {
        "Kakashi is unique, he isn't Uchiha but have their eyes gifted by his Uchiha child friend"
    }

}

//let sasuke = Sasuke()
//sasuke.about()
//print(sasuke.jutsu())
//sasuke.susanooColor()
//print()
//
//let kakashi = Kakashi()
//kakashi.about()
//kakashi.susanooColor()
//print()
//
//let sarada = Sarada(otherAbility: "strong physical")
//print(sarada.jutsu())
//sarada.susanooColor()

let uchiha = Uchiha(susanoo: "biru", name: "ini 7")
uchiha.name = "ini 9"
uchiha.name = "ini 10"
uchiha.name = "ini 11"

print(uchiha.name)

//class Progress {
//    var task: String
//    var amount: Int {
//        didSet {
//            print("\(task) is now \(amount)% complete")
//        }
//    }
//    init(task: String, amount: Int) {
//        self.task = task
//        self.amount = amount
//    }
//}
//
//var progress = Progress(task: "Loading data", amount: 0)
//
//progress.amount = 30
//progress.amount = 80
//progress.amount = 100



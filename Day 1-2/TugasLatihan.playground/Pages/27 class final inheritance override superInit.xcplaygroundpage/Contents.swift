class Book{
    var id: Int
    var genre: [String]
    let page = 300
    
    init(id: Int, genre: [String]) {
        self.id = id
        self.genre = genre
    }
    
    func bookDetails() -> String{
        "Book with id:\(id) have about \(page) pages"
    }
}

class HarryPotter: Book{
    override func bookDetails() -> String {
        "Ini buku harry potter"
    }
}

var harryPotter = HarryPotter(id: 91, genre: ["Adventure", "Action"])
var book = Book(id: 21, genre: ["Unknown"])
print(harryPotter.bookDetails())
print(book.bookDetails())


class Uchiha {
    let element = "Fire"
    let uniqueAbilitiy = "Sharinggan"
    var susanoo: String 
    var name: String
    
    init(susanoo: String, name: String){
        self.susanoo = susanoo
        self.name = name
    }
    
    func about(){
        print("All Uchihas have fire as their nature element")
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
    override func about() {
        print("Kakashi is unique, he isn't Uchiha but have their eyes gifted by his Uchiha child friend")
    }
    
}

let sasuke = Sasuke()
sasuke.about()
print(sasuke.jutsu())
sasuke.susanooColor()
print()

let kakashi = Kakashi()
kakashi.about()
kakashi.susanooColor()
print()

let sarada = Sarada(otherAbility: "strong physical") 
print(sarada.jutsu())
sarada.susanooColor()



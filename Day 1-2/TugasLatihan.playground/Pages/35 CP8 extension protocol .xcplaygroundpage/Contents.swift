
protocol Building {
    var rooms: Int { get }
    var cost: Int { get }
    var agentName: String { get }
    func summary()
}

extension Building{
    func summary() {
        print("The Building has \(rooms) rooms and costed around \(cost) dollar by Agent \(agentName)")
    }
}

struct House: Building {
    let rooms = 3
    let cost = 50_000
    let agentName = "Mr Krabs"
}

struct Office: Building {
    let rooms: Int
    let cost: Int
    let agentName = "Fahmi"

}

//extension Office {
//    init(rooms: Int, cost:Int, ) {
//        self.rooms = rooms
//        self.cost = cost
//        self.agentName = agentName
//    }
//}

let house = House()
house.summary()

let office = Office(rooms: 10,cost: 200_000)
//let office1 = Office(rooms: <#Int#>, cost: <#Int#>, agentName: <#String#>)
office.summary()

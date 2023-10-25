
protocol Heroes {
    var name: String { get }
    var isSClass: Bool { get }
    
    func estimatedArrived(for distance: Int) -> Int
    func travel(about distance: Int)
}

struct MumenRider: Heroes {
    let name = "Mumen Rider"
    var isSClass = false    
    func estimatedArrived(for distance: Int) -> Int {
        distance/5
    }
    func travel(about distance: Int) {
        print("\(name) is running \(distance) km")
    }
}

struct Bang: Heroes {
    let name = "Bang"
    var isSClass = true
    func estimatedArrived(for distance: Int) -> Int {
        distance/50
    }
    func travel(about distance: Int) {
        print("\(name) is running \(distance) km")
    }
}

func heroToHelp(distance: Int, choose heroes: Heroes){
    if heroes.estimatedArrived(for: distance) > 20 {
        print("Choose better heroes to help you next time")
    } else {
        heroes.travel(about: distance)
    }
}

func howLong(distance: Int, choose heroes: [Heroes]){
    for hero in heroes{
        let estimate = hero.estimatedArrived(for: distance)
        print("\(hero.name) takes \(estimate) hours to travel \(distance) km")
    }
}

let mumenRider = MumenRider()
let bang = Bang()

heroToHelp(distance: 10, choose: mumenRider)
heroToHelp(distance: 50, choose: bang)
print()
howLong(distance: 50, choose: [bang, mumenRider])


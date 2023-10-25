
// CHECKPOINT 6 - Car Sturct
//create a struct to store information about a car, 
//including its model, 
//number of seats, 
//and current gear, 
//then add a method to change gears up or down. 
//Have a think about variables and access control: 
//what data should be a variable rather than a constant, and what data should be exposed publicly? 
//Should the gear-changing method validate its input somehow?


struct Car {
    static let model = "McLaren 720s"
    private let numberOfSeats = 2
    var currentGear: Int {
        didSet {
            print("Gears changed from \(oldValue) to \(currentGear)")
        }
    }
    
    init(currentGear: Int){
        self.currentGear = currentGear
    }
    
    mutating func gearsUp() -> Int {
        var boolCar = (currentGear >= 1 && currentGear <= 10)
        if boolCar {
            currentGear += 1
        } else {
            print("Invalid gear")
        }
        return currentGear
    }
    
    mutating func gearsDown() -> Int {
        var boolCar = (currentGear >= 1 && currentGear <= 10)
        if boolCar {
            currentGear -= 1
        } else {
            print("Invalid gear")
        }
        return currentGear
    }
    
}

print(Car.model)
var car1 = Car(currentGear: 1)
car1.gearsUp()
car1.gearsUp()
car1.gearsDown()
print(car1.currentGear)

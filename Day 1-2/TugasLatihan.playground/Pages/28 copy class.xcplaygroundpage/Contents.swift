// constant class, constant properties: fixed signpost, can't change properties value
// constant class, variable properties: fixed signpost, can change properties value
// variable class, constant properties: can change signpost, can't change properties value
// variable class, variable properties: can change signpost, can change properties value


class Naruto {
    var status = "Genin"
    
    func copy() -> Naruto {
        let naruto = Naruto()
        naruto.status = status
        // "naruto.status" refer to parent, "status" refer to instances used outside class 
        return naruto
    }
    deinit { // auto run when last copy instances is destroyed
        print("I am dead")
    }
}

let naruto1 = Naruto()
let naruto2 = naruto1.copy()
naruto2.status = "Hokage" // copy class with different value/ unique
let naruto3 = naruto2.copy()
naruto3.status = "Non tail"
let naruto4 = naruto3 // naruto 3 & 4 shared value cause class is refence type
naruto4.status = "Sannin mode"

print(naruto1.status)
print(naruto2.status)
print(naruto3.status)
print(naruto4.status)

for i in 1...5 {
    let naruto5 = Naruto().status
}

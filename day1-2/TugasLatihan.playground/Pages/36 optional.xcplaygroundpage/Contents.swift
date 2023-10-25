// optional:
// 1. If let, run if there is a value
// 2. Guard let, run if theres no value
// guard required return inside func
// 3. ?? nil coalescing

let iphones = ["8","x","11", "12", "13"]

var inDevelopeiPhone: String?
//inDevelopeiPhone = "15"

//if let inDevelopeiPhone = inDevelopeiPhone { // if let optional
// run if there is a value
//    print("New iPhone \(inDevelopeiPhone)")
//}else {
//    print("Lastest iPhone still iPhone \(iphones.last ?? "") ") // ?? means nil coalescing
//}

func checkError() { // run if there is no value
    guard let inDevelopeiPhone = inDevelopeiPhone else {
        print("Latest iPhone still iPhone \(iphones.last ?? "N/A")") 
        return
    }
    print("New iPhone \(inDevelopeiPhone)")
}

checkError()

extension Array {
    func isNotEmpty() -> Bool {
        return !isEmpty
    }
}

func checkError2() {
    guard iphones.isNotEmpty() else {
        print("The array is Empty")
        return
    }
    print("\nThe array is not Empty")
    func iphoneInfo(_ iphones: [String]) ->String {
        var info = ""
        for i in iphones{
            info += "iPhone \(i)\n"
        }
        return info
    }

    let result = iphoneInfo(iphones)
    print(result)

}
checkError2()

let number: String = ""
let stringToInt = Int(number) ?? 0 // nil coalesing
print(stringToInt)

struct Book {
    let title: String
    let author: String?
}

print()

var book: Book? = nil
let author = book?.author?.first?.uppercased() ?? "A"
// book?.author?.first? this is multiple opt chaining, 3/all of them must have value, otherwise run nil coalesing which is ?? and print "A"
// This condition is rare in practice
print(author)

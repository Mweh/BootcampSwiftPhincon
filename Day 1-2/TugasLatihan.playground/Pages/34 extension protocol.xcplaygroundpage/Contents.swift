//import  Cocoa

protocol Comic {
    var title: String { get }
    var chapter: Int { get }
    var isFromJapan: Bool { get }
    func info()
    var name: String? { get }
}
extension Comic { // We use them to add functionality directly to protocols, which means we don’t need to copy that functionality across many structs and classes.
    func info() {
        if isFromJapan {
            print("\(title) have \(chapter) chapter and it's from Japan")
        } else {
            print("\(title) have \(chapter) chapters and it's not from Japan")
        }
    }
}

struct Naruto: Comic {
    let title = "Naruto"
    let chapter: Int = 500
    let isFromJapan = true
    let name: String? = nil
//    func info() {
//        print("This is not default, in other words a manually info()")
//        }
}

let naruto = Naruto()
naruto.info()

// Protocol extensions are used everywhere in Swift, which is why you’ll often see it described as a “protocol-oriented programming language" or POP in short. 

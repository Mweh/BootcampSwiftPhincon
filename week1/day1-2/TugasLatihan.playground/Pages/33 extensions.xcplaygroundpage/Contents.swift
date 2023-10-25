import Cocoa

extension String {
    func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    mutating func trim() {
        self = self.trimmed()
    }
    
}

var myName = "        Just call me Fahmi please, thank you! "
print(myName.trimmed())

//let trimmed = myName.trimmingCharacters(in: .whitespacesAndNewlines)

//print(myName.trimmingCharacters(in: .whitespaces))
//print(myName.trimmed())
//print()

struct Book {
    let title: String
    let pageCount: Int
    let readingHours: Int
}

extension Book{   
    init(title: String, pageCount: Int) {
        self.title = title
        self.pageCount = pageCount
        self.readingHours = pageCount / 50
    }
}

let book = Book(title: "Song of ice and fire", pageCount: 2323)
let book2 = Book(title: "Re:zero Novel", pageCount: 1202, readingHours: 88)
print(book.readingHours)
print(book2.readingHours)


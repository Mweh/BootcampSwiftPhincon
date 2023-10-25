enum RGB: String{
    case Red, Green, Blue
}

func test(type: RGB) -> String {
    switch type {
    case .Red:
        return "ini merah"
    case .Green:
        return "ini hijau"
    default:
        return "ini biru"
    }
}

test(type: .Blue)


var greeting = "Hello, playground"

print(greeting)

let myName = "I am Fahmi!"

print(myName)

greeting = "I am changed!"

print(greeting)

var ryfat = "kakak"

var fullName = "Muhammad Fahmi"

var shortName = "Fahmi"

func sapaan(greeting: String) -> (String) -> (String) {
    { name in "\(greeting) \(name)" }
}

let halo = sapaan(greeting: "Hello")

halo("Muhammad") // prints "Hello Muhammad"
halo("Fahmi") // prints "Hello Fahmi"

// function yg tipe datanya enum


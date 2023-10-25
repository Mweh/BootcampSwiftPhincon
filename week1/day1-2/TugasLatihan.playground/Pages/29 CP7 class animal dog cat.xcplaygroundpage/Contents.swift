//The Animal class should have a legs integer property that tracks how many legs the animal has.
//The Dog class should have a speak() method that prints a generic dog barking string, but each of the subclasses should print something slightly different.
//The Cat class should have a matching speak() method, again with each subclass printing something different.
//The Cat class should have an isTame Boolean property, provided using an initializer.

class Animal {
    let legs = 4
}
class Dog: Animal {
    func speak(){
        print("Bark...bark")
    }
}
final class Corgi: Dog {
    override func speak(){
        print("Gong...gong")
    }
}
final class Poodle: Dog {
    override func speak(){
        print("Burk...burk")
    }
}
class Cat: Animal {
    let isTame: Bool
    init(isTame: Bool) {
        self.isTame = isTame
    }
    func speak(){
        print("Meow...meow")
    }
}
final class Persian: Cat {
    init() {
        super.init(isTame: true)
    }
    override func speak(){
        print("Miauow...miauw")
    }
}
final class Lion: Cat {
    init() {
        super.init(isTame: false)
    }
    override func speak(){
        print("Rawr...rawr")
    }
}

let animal = Animal()
print(animal.legs)
print()

let dog = Dog()
print(dog.legs)
dog.speak()
print()

let corgi = Corgi()
print(corgi.legs)
corgi.speak()
print()

let poodle = Poodle()
print(poodle.legs)
poodle.speak()
print()

let cat = Cat(isTame: false)
print(cat.legs)
cat.speak()
print()

let persian = Persian()
print(persian.legs)
persian.speak()
print(persian.isTame)
print()

let lion = Lion()
print(lion.legs)
lion.speak()
print(lion.isTame)
print()

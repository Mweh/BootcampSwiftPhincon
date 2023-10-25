// CLOSURE
// draw a yugioh card monster, random stars, 1-4 only summon w/o sacrifice needed

let drawCards = { () -> Int in
    var yugiMonsterStars = Int.random(in: 1...12)
//    print("The monster star is \(yugiMonsterStars)")
    return yugiMonsterStars 
}

var cardHand:Array<Int> = [] 
var lowStarMonster:Array<Int> = []

for i in 1...5 {
    let draw = drawCards()
    cardHand.append(draw)
    
    if draw <= 4 {
        lowStarMonster.append(draw)
    }
}


let hand = { (when: String) in
    print("\(when), your's  handcards = \(cardHand)")
        var lowStarMonstersInHand: [Int] = []
            for card in cardHand {
                if card <= 4 {
                    lowStarMonstersInHand.append(card)
                }
            }
        print("\(when), your low star monstar = \(lowStarMonstersInHand)")
        print("\(when), you have \(lowStarMonstersInHand.count) low star of \(cardHand.count) card")
        print()
}

hand("[1st turn]")

let drawAnotherCard = { ()
    let draw1Card = drawCards()

    print("You draw 1 card, \(draw1Card) starred monster!")

    if draw1Card <= 4{
        print("You can summon \(draw1Card) star immediately!")
    } else if draw1Card == 12 {
        print("You draws strong monster!!")
    } else {
        print("Sacrifice <=4 starred monster to summon \(draw1Card) star")
    }
    cardHand.append(draw1Card)
    print()
}

drawAnotherCard()
drawAnotherCard()
drawAnotherCard()

hand("Currently")


//func brewTea(steps: () -> Void) {
//    print("Get tea")
//    print("Get milk")
//    print("Get sugar")
//    steps()
//}
//brewTea {
//    print("Brew tea in teapot.")
//    print("Add milk to cup")
//    print("Pour tea into cup")
//    print("Add sugar to taste.")
//}
//
//func repeatAction(count: Int, action: () -> Void) {
//    for _ in 0..<count {
//        action()
//    }
//}
//repeatAction(count: 5) {
//    print("Hello, world!")
//}

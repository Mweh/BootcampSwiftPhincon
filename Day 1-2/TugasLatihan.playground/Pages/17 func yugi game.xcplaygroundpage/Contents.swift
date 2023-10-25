//: [Previous](@previous)
// draw a yugioh card monster, random stars, 1-4 only summon w/o sacrifice needed

//func drawCards(kartu: String) -> Int? {
//    var yugiMonsterStars = Int.random(in: 1...12)
////    print("The monster star is \(yugiMonsterStars)")
////    return /*yugiMonsterStars*/ ?? "0"
//    return Int(kartu)
//}

//if let drawCard = drawCards(kartu: "123"){
//    print("draw card")
//}

//drawCards()
//drawCards()
//drawCards()
//drawCards()

func drawCards() -> Int {
    var yugiMonsterStars = Int.random(in: 1...12)
    print("The monster star is \(yugiMonsterStars)")
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

func hand(when: String){
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


hand(when: "[1st turn]")

func drawAnotherCard(){
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

hand(when: "Currently")

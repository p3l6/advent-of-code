import Foundation
import Shared

@main @dayMain struct DayRunner: Runnable {
    let dayNumber = 7
    let tests = [
        TestCase("""
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
""", .both(6440, 5905))
    ]
}

struct Hand: Comparable {
    enum Card: Comparable {
        case A, K, Q, J, T, nine, eight, seven, six, five, four, three, two, joker
    }
    enum Label: Comparable {
        case fiveKind, fourKind, fullHouse, threeKind, twoPair, onePair, high
        
        init(_ cards: [Card]) {
            var countsByCard = cards.reduce(into: [:]) { $0[$1, default: 0] += 1 }
            let jokers = countsByCard.removeValue(forKey: .joker) ?? 0
            let counts = countsByCard.values.sorted(by: >)
            let highest = counts.first ?? 0
            let second = counts.count > 1 ? counts[1] : 0

            if highest + jokers == 5 { self = .fiveKind }
            else if highest + jokers == 4 { self = .fourKind }
            else if highest + second + jokers == 5 { self = .fullHouse }
            else if highest + jokers == 3 { self = .threeKind }
            else if highest + second + jokers == 4 { self = .twoPair }
            else if highest + jokers == 2 { self = .onePair }
            else { self = .high }
        }
    }

    let cards: [Card]
    let bid: Int
    let label: Label

    init(cards: String, bid: Int, usingJokers: Bool = false) {
        self.bid = bid
        self.cards = cards.map {
            switch $0 {
            case "A": .A
            case "K": .K
            case "Q": .Q
            case "J": usingJokers ? .joker : .J
            case "T": .T
            case "9": .nine
            case "8": .eight
            case "7": .seven
            case "6": .six
            case "5": .five
            case "4": .four
            case "3": .three
            case "2": .two
            default: preconditionFailure()
            }
        }

        label = Label(self.cards)
    }

    static func < (lhs: Hand, rhs: Hand) -> Bool {
        if lhs.label == rhs.label {
            return lhs.cards.lexicographicallyPrecedes(rhs.cards)
        }
        return lhs.label < rhs.label
    }
}

func day(_ input: Input) -> Answer {
    let hands = input.lines.map {
        let match = $0.wholeMatch(of: /([2-9AKQJT]+) +([0-9]+)/)!
        return Hand(cards: String(match.1), bid: Int(match.2)!)
    }

    let partOne = hands
        .sorted(by: >)
        .enumerated()
        .map { (rank, hand) in hand.bid * (rank+1) }
        .sum

    let jokerHands = input.lines.map {
        let match = $0.wholeMatch(of: /([2-9AKQJT]+) +([0-9]+)/)!
        return Hand(cards: String(match.1), bid: Int(match.2)!, usingJokers: true)
    }

    let partTwo = jokerHands
        .sorted(by: >)
        .enumerated()
        .map { (rank, hand) in hand.bid * (rank+1) }
        .sum

    return .both(partOne, partTwo)
}

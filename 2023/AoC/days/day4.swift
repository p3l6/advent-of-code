import Foundation
import Shared

@main @dayMain struct DayRunner: Runnable {
    let dayNumber = 4
    let tests = [
        TestCase("""
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
""", .both(13, 30))
    ]
}

struct LottoCard {
    let numbers: Set<Int>
    let winningNumbers: Set<Int>
    var copies = 1
    let winners: Int
    let points: Int

    init(string: String) {
        let parts = string.trimmingPrefix(/Card +\d+:/).split(separator: "|")
        winningNumbers = parts[0].split(separator: " ").map{Int($0)!}.set
        numbers = parts[1].split(separator: " ").map{Int($0)!}.set
        
        winners = winningNumbers.intersection(numbers).count
        points = winners > 0 ? 1 << (winners - 1) : 0
    }

}


func day(_ input: Input) -> Answer {
    var cards = input.lines.map(LottoCard.init(string:))

    for i in 0..<cards.endIndex {
        let card = cards[i]
        let begin = i+1
        let end = min(i+card.winners+1, cards.endIndex)
        guard begin < end else { continue }
        for j in begin..<end {
            cards[j].copies += cards[i].copies
        }
    }

    return .both(cards.map(\.points).sum,
                 cards.map(\.copies).sum)
}


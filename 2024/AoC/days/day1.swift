
import Foundation
import Shared

@main @dayMain struct DayRunner: Runnable {
    let dayNumber = 1
    let tests = [
        TestCase("""
 3   4
 4   3
 2   5
 1   3
 3   9
 3   3
 """, .one(11) + .two(31))
    ]
}

func day(_ input: Input) -> Answer {
    let (a, b): ([Int], [Int]) = input.lines
        .map { $0.split(separator: "   ") }
        .reduce(into: ([], [])) { $0.0.append(Int($1.first!)!); $0.1.append(Int($1.last!)!) }

    let aSorted = a.sorted()
    let bSorted = b.sorted()

    var difference = 0

    for (x, y) in zip(aSorted, bSorted) {
        difference += abs(x-y)
    }

    let bIndex = b.reduce(into: [:]) { $0[$1] = ($0[$1] ?? 0) + 1 }
    var similarity = 0

    for x in aSorted {
        similarity += x * (bIndex[x] ?? 0)
    }

    return .one(difference) + .two(similarity)
}



import Foundation
import Shared

@main @dayMain struct DayRunner: Runnable {
    let dayNumber = 8
    let tests = [
        TestCase("""
 LLR

 AAA = (BBB, BBB)
 BBB = (AAA, ZZZ)
 ZZZ = (ZZZ, ZZZ)
 """, .one(6)),
//        TestCase("""
// LR
//
// 11A = (11B, XXX)
// 11B = (XXX, 11Z)
// 11Z = (11B, XXX)
// 22A = (22B, XXX)
// 22B = (22C, 22C)
// 22C = (22Z, 22Z)
// 22Z = (22B, 22B)
// XXX = (XXX, XXX)
// """, .two(6)),
    ]
}


struct Network {
    let nodes: [String: (String, String)]

    init(_ lines: any Sequence<String>) {
        nodes = lines.reduce(into: [String: (String, String)]()) { dict, line in
            let match = line.wholeMatch(of: /([A-Z]+) = \(([A-Z]+), ([A-Z]+)\)/)!
            return dict[String(match.1)] = (String(match.2), String(match.3))
        }
    }

    func left(from: String) -> String { nodes[from]!.0 }
    func right(from: String) -> String { nodes[from]!.1 }
    func move(_ dir: Character, from location: String) -> String {
        switch dir {
        case "L": return left(from: location)
        case "R": return right(from: location)
        default: preconditionFailure()
        }
    }
}

func day(_ input: Input) -> Answer {
    let lines = input.lines
    let pattern = lines.first!
    let network = Network(lines[1...])

    var steps = 0
    var index = pattern.startIndex
    var location = "AAA"

    while location != "ZZZ" {
        location = network.move(pattern[index], from: location)

        index = pattern.index(after: index)
        if index == pattern.endIndex { index = pattern.startIndex }
        steps += 1
    }

    let partOne = Answer.one(steps)

    steps = 0
    index = pattern.startIndex
    var locations = network.nodes.keys.filter { $0.hasSuffix("A") }

// TODO: part two: cycle detection. find first two Z nodes for each. Then find first common step from those strides.

//    while locations.contains(where: { !$0.hasSuffix("Z") }) {
//        locations = locations.map { network.move(pattern[index], from: $0) }
//
//        index = pattern.index(after: index)
//        if index == pattern.endIndex { index = pattern.startIndex }
//        steps += 1
//    }

    return partOne + .two(steps)
}

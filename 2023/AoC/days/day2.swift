import Shared
import Foundation

@main @dayMain struct DayRunner: Runnable {
    let dayNumber = 2
    let tests = [
        TestCase("""
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
""", .both(8, 2286))
    ]
}

struct Game {
    let number: Int
    let rounds: [(red: Int, green: Int, blue: Int)]

    init(_ line: String) {
        let gameRegex = /Game ([0-9]+):/
        number = Int(line.firstMatch(of: gameRegex)!.1)!
        
        let remaining = line.trimmingPrefix(gameRegex)
        rounds = remaining.split(separator: ";").map { part in
            let r = if let match = part.firstMatch(of: /([0-9]+) red/) { Int(match.1)! } else { 0 }
            let g = if let match = part.firstMatch(of: /([0-9]+) green/) { Int(match.1)! } else { 0 }
            let b = if let match = part.firstMatch(of: /([0-9]+) blue/) { Int(match.1)! } else { 0 }
            return (r, g, b)
        }

    }

    func possibleWith(red: Int, green: Int, blue: Int) -> Bool {
        for round in rounds {
            if round.red > red || round.green > green || round.blue > blue {
                return false
            }
        }
        return true
    }

    var requiredBlocks: (red: Int, green: Int, blue: Int) {
        var red = 0
        var green = 0
        var blue = 0

        for round in rounds {
            red = max(red, round.red)
            green = max(green, round.green)
            blue = max(blue, round.blue)
        }

        return (red, green, blue)
    }
}

func day(_ input: Input) -> Answer {
    let games = input.lines.map(Game.init)

    let partOne = games
        .filter { $0.possibleWith(red: 12, green: 13, blue: 14)  }
        .map(\.number)
        .sum

    let partTwo = games
        .map(\.requiredBlocks)
        .map{ (r, g, b) in r * g * b }
        .sum

    return .one(partOne) + .two(partTwo)
}


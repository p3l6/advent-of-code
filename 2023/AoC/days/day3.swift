
import Foundation
import Shared

@main @dayMain struct DayRunner: Runnable {
    let dayNumber = 3
    let tests = [
        TestCase("""
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
""", .both(4361, 467835))
    ]
}

struct PotentialPartLabel {
    let number: Int
    let grid: SubGrid<Character>
    let symbol: Character?
    let symbolLocation: Loc?

    init(number: Int, grid: SubGrid<Character>) {
        self.number = number
        self.grid = grid
        
        var symbol: Character? = nil
        var symbolLocation: Loc? = nil
        for (loc, char) in grid.iterator() {
            switch char {
            case "0"..."9", ".": break
            default:
                symbol = char
                symbolLocation = grid.locInTopGrid(loc)
            }
        }

        self.symbol = symbol
        self.symbolLocation = symbolLocation
    }
}

func day(_ input: Input) -> Answer {
    var parts = [PotentialPartLabel]()

    let grid = input.grid
    let textLines = input.lines

    for (row, rowText) in textLines.enumerated() {
        for match in rowText.matches(of: /(\d+)/) {
            parts.append(PotentialPartLabel(
                number: Int(rowText[match.range])!,
                grid: grid.subgrid(
                    from: Loc(row: row-1, col: match.range.lowerBound.utf16Offset(in: rowText)-1),
                    to: Loc(row: row+1, col: match.range.upperBound.utf16Offset(in: rowText)))))
        }
    }

    let gears: [Int] = parts
        .reduce(into: [Loc: [PotentialPartLabel]]()) { dict, part in
            if let loc = part.symbolLocation, part.symbol == "*" {
                dict[loc, default: []].append(part)
            }
        }
        .filter { (_, parts) in
            parts.count == 2
        }
        .map { (_, parts) in
            parts[0].number * parts[1].number
        }

    return .both(
        parts
            .filter { $0.symbol != nil }
            .map(\.number)
            .sum,
        gears.sum)
}

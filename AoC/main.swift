//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input = puzzleInput
"""
     |
     |  +--+
     A  |  C
 F---|----E|--+
     |  |  |  D
     +B-+  +--+
"""
let map :[[Character]] = input.split(separator: "\n").map { [Character]($0.characters) }
// map[row][col]

enum Direction {
    case up
    case down
    case left
    case right
    case none
    var opposite :Direction {
        switch self {
        case .up: return .down
        case .down: return .up
        case .left: return .right
        case .right: return .left
        case .none: return .none
        }
    }
}

struct Location {
    let row :Int
    let col :Int
    let dir :Direction
    
    init(row:Int,col:Int,dir:Direction = .none) {self.row = row; self.col = col; self.dir = dir}
    
    func isValid() -> Bool {
        return row >= 0 && row < map.count && col >= 0 && col < map[row].count
    }
    
    func move() -> Location { return self.move(self.dir) }
    func move(_ dir: Direction) -> Location {
        switch dir {
        case .down: return Location(row:self.row+1, col:self.col, dir:.down)
        case .up: return Location(row:self.row-1, col:self.col, dir:.up)
        case .left: return Location(row:self.row, col:self.col-1, dir:.left)
        case .right: return Location(row:self.row, col:self.col+1, dir:.right)
        default: return self
        }
    }
    
    func canTurn(_ dir: Direction) -> Bool {
        let nextLoc = move(dir)
        return self.dir != dir && self.dir != dir.opposite && nextLoc.isValid() && map[nextLoc] != " "
    }
}

extension Array where Element == [Character] {
    subscript (loc:Location) -> Character {
        get { return self[loc.row][loc.col] }
        set { self[loc.row][loc.col] = newValue }
    }
}

var visited = ""
var loc = Location(row:0, col:map[0].index(of: "|")!, dir:.down)
var stepCount = 1

mainLoop: while loc.isValid() {
    switch map[loc] {
    case "|", "-":
        loc = loc.move()
    case "+":
        if      loc.canTurn(.down) { loc = loc.move(.down) }
        else if loc.canTurn(.up)   { loc = loc.move(.up) }
        else if loc.canTurn(.left) { loc = loc.move(.left) }
        else if loc.canTurn(.right){ loc = loc.move(.right) }
        else                       { print("error: dead end plus"); break mainLoop }
    case " ":
        break mainLoop // dead end found
    default:
        visited.append(map[loc])
        loc = loc.move()
    }
    stepCount+=1
}

if !loc.isValid() { print("error: moved to invalid location") }

print("part one: \(visited)") // ITSZCJNMUO

print("part two: \(stepCount)") // 17420

execTime.end()

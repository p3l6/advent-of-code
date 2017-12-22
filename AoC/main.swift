//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input = puzzleInput

var infected = Set<Point>()

let lines = input.split(separator: "\n")
let inputWidth = lines.first!.count
let inputHeight = lines.count
for x in 0..<inputWidth {
    for y in 0..<inputHeight {
        if String(lines[y])[x] == "#" {
            infected.insert(Point(x:x-inputWidth/2, y:inputHeight/2-y))
        }
    }
}
let initialInfected = infected

var curPos = Point(x:0, y:0)
var direction = Direction.north
var infectCount = 0

for _ in 0 ..< 10_000 {
    if infected.contains(curPos) {
        direction = direction.right
        infected.remove(curPos)
    } else {
        direction = direction.left
        infected.insert(curPos)
        infectCount += 1
    }
    curPos = curPos.move(direction)
}

print("part one: \(infectCount)") // 5552

enum State {
    case infected
    case weak
    case flagged
    case clean
}

curPos = Point(x:0, y:0)
direction = Direction.north
infectCount = 0
var grid = [Point:State]()
initialInfected.forEach{ grid[$0] = .infected }

for _ in 0 ..< 10_000_000 {
    switch grid[curPos] ?? .clean {
    case .infected:
        direction = direction.right
        grid[curPos] = .flagged
    case .flagged:
        grid[curPos] = .clean
        direction = direction.back
    case .weak:
        grid[curPos] = .infected
        infectCount += 1
    case .clean:
        direction = direction.left
        grid[curPos] = .weak
    }
    curPos = curPos.move(direction)
}

print("part two: \(infectCount)")  // 2511527

execTime.end()

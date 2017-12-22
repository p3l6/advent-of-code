//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input = puzzleInput

enum Direction {
    case north
    case south
    case east
    case west
    
    var right :Direction {
        switch self {
        case .north: return .east
        case .south: return .west
        case .east: return .south
        case .west: return .north
        }
    }
    
    var left :Direction {
        switch self {
        case .north: return .west
        case .south: return .east
        case .east: return .north
        case .west: return .south
        }
    }
    
    var back :Direction {
        switch self {
        case .north: return .south
        case .south: return .north
        case .east: return .west
        case .west: return .east
        }
    }
}

struct Point :Hashable {
    let x :Int
    let y :Int
    
    static func ==(a:Point, b:Point) -> Bool { return a.x==b.x && a.y==b.y }
    var hashValue: Int { return x | y<<32 }
    
    func move(_ d:Direction) -> Point {
        switch d {
        case .north: return Point(x:x, y:y+1)
        case .south: return Point(x:x, y:y-1)
        case .east: return Point(x:x+1, y:y)
        case .west: return Point(x:x-1, y:y)
        }
    }
}

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


curPos = Point(x:0, y:0)
direction = Direction.north
infected = initialInfected
infectCount = 0
var weakened = Set<Point>()
var flagged = Set<Point>()

for _ in 0 ..< 10_000_000 {
    if infected.contains(curPos) {
        direction = direction.right
        infected.remove(curPos)
        flagged.insert(curPos)
    } else if flagged.contains(curPos){
        flagged.remove(curPos)
        direction = direction.back
    } else if weakened.contains(curPos){
        weakened.remove(curPos)
        infected.insert(curPos)
        infectCount += 1
    } else /* Clean */ {
        direction = direction.left
        weakened.insert(curPos)
    }
    curPos = curPos.move(direction)
}

print("part two: \(infectCount)")  // 2511527

execTime.end()

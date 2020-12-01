//
//  day20.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay20 = false

enum DonutTile {
    case void
    case warp
    case hallway
    case wall
}

func day20 (_ input:String) -> Solution {
    var solution = Solution()
    var lines = input.split(separator:"\n").map { String($0) } // .lines() trims the whitespace
    let width = lines.reduce(0) { return max($0, $1.count) }
    lines = lines.map { $0.padding(toLength: width, withPad: " ", startingAt:0)}
    
    let map = FiniteGrid(defaultValue: DonutTile.void, area: Area(at: Point(0,0), w: width, h: lines.count))
    var rawWarps = [(warp:Point, hall:Point, id:String)]()
    
    for (y, line) in lines.enumerated() {
        for (x, char) in line.enumerated() {
            let loc = Point(x,y)
            switch char {
            case "#": map[loc] = .wall
            case " ": map[loc] = .void
            case ".": map[loc] = .hallway
            case "A"..."Z":
                let nearbyHall = loc.adjacents().filter({map.area.contains($0) && "." == lines[$0.y][$0.x]}).first
                if let hall = nearbyHall {
                    map[loc] = .warp
                    let nearbyPoint = loc.adjacents().filter({
                        map.area.contains($0) &&
                        CharacterSet.uppercaseLetters.contains(UnicodeScalar(lines[$0.y][$0.x])!)
                    }).first!
                    let nearbyChar = lines[nearbyPoint.y][nearbyPoint.x]
                    // assume we wont have both DK and KD in the same map
                    let id = loc.x == nearbyPoint.x ?
                        loc.y < nearbyPoint.y ? "\(char)\(nearbyChar)" : "\(nearbyChar)\(char)"
                        : loc.x < nearbyPoint.x ? "\(char)\(nearbyChar)" : "\(nearbyChar)\(char)"
                    rawWarps.append((warp:loc, hall: hall, id:id))
                } else {
                    map[loc] = .void
                }
            default: assertionFailure("Unexpected input char: \(char)")
            }
        }
    }
    
    var warps = [Point:Point]()
    var entrance = Point(0,0)
    var exit = Point(0,0)

    for (point, hall, id) in rawWarps {
        if id == "AA" {
            entrance = hall
            map[point] = .void
        } else if id == "ZZ" {
            exit = hall
        } else {
            let others = rawWarps.filter { $0.id == id && $0.warp != point}
            assert(others.count == 1, "warps don't make sense!")
            let other = others.first!
            warps[point] = other.hall
        }
    }
    
    let distMap = FiniteGrid(defaultValue: Int.max, area: map.area)
    distMap[entrance] = 0
    var toVisit = [entrance]
    
    while distMap[exit] == Int.max {
        var nextVisit = [Point]()
        for v in toVisit {
            let depth = distMap[v]
            for n in v.adjacents() {
                if distMap[n] != Int.max { continue }
                switch map[n] {
                case .void, .wall:
                    continue
                case .hallway:
                    distMap[n] = depth + 1
                    nextVisit.append(n)
                case .warp:
                    let dest = warps[n]!
                    distMap[dest] = depth + 1
                    nextVisit.append(dest)
                }
            }
        }
        toVisit = nextVisit
    }
    
    solution.partOne = "\(distMap[exit])"
//    solution.partTwo = "\()"
    return solution
}

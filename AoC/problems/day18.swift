//
//  day18.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay18 = true

enum Acre {
    case ground     // .
    case trees      // |
    case lumberyard // #
}

typealias LumberZone = FiniteGrid<Acre>

func processMinute(_ zone:LumberZone) -> LumberZone {
    let area = zone.area
    let next = LumberZone(defaultValue: .ground, area: area)
    for p in area {
        let acre = zone[p]
        var treeCount = 0, lumberCount = 0
        for adj in p.adjacent8() {
            if area.contains(point: adj) {
                switch zone[adj] {
                case .ground: continue
                case .trees: treeCount += 1
                case .lumberyard: lumberCount += 1
                }
            }
        }
        switch acre {
        case .ground: next[p] = treeCount >= 3 ? .trees : .ground
        case .trees: next[p] = lumberCount >= 3 ? .lumberyard : .trees
        case .lumberyard: next[p] = lumberCount >= 1 && treeCount >= 1 ? .lumberyard : .ground
        }
    }
    return next
}

func countLumber(_ zone:LumberZone) -> (trees:Int, lumber:Int) {
    var treeCount = 0, lumberCount = 0
    for p in zone.area {
        switch zone[p] {
        case .ground: continue
        case .trees: treeCount += 1
        case .lumberyard: lumberCount += 1
        }
    }
    return (treeCount,lumberCount)
}

func day18 (_ input:String) -> Solution {
    let lines = input.lines()
    let area = Area(at:Point(0,0), w:lines.first!.count, h:lines.count)
    
    var zone = LumberZone(defaultValue: .ground, area: area)
    
    for p in area {
        let char = lines[p.y][p.x]
        switch char {
        case "#": zone[p] = .lumberyard
        case "|": zone[p] = .trees
        case ".": continue
        default: assertionFailure("unexpected character: \(char)")
        }
    }
    
    var minutes = 0
    while minutes < 10 {
        zone = processMinute(zone)
        minutes += 1
    }
    
    var (treeCount,lumberCount) = countLumber(zone)
    
    var solution = Solution()
    solution.partOne = "\(treeCount * lumberCount)"
    
    while minutes < 1_000_000_000 {
        zone = processMinute(zone)
        minutes += 1
    }
    
    (treeCount,lumberCount) = countLumber(zone)
    solution.partTwo = "\(treeCount * lumberCount)"
    return solution
}

//
//  day3.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay3 = false

func getGrid(_ strPath:String) -> InfiniteGrid<Int> {
    let path = InfiniteGrid(defaultValue: 0)
    var pos = Point(0,0)
    var steps = 0
    for seg in strPath.stringArray(",") {
        let dir :Direction = { () -> Direction in
            switch seg.first! {
            case "R": return Direction.east
            case "L": return Direction.west
            case "D": return Direction.south
            case "U": return Direction.north
            default:
                print("unexpected direction!")
                abort()
            }
        }()
        let dist = Int(seg.substring(fromIndex: 1))!
        for _ in 0..<dist {
            pos = pos.move(dir)
            steps += 1
            path[pos] = steps
        }
    }
    return path
}

func day3 (_ input:String) -> Solution {
    var solution = Solution()
    let lines = input.lines()
    
    let wire1path = getGrid(lines[0])
    let wire2path = getGrid(lines[1])
    
    var minDist = Int.max
    var minDelay = Int.max
    wire1path.forEach { (p, steps1) in
        let steps2 = wire2path[p]
        if steps1 > 0 && steps2 > 0 {
            let dist = p.taxi(to: Point(0,0))
            if dist < minDist {
                minDist = dist
            }
            if steps1 + steps2 < minDelay {
                minDelay = steps1 + steps2
            }

        }
    }
    
    solution.partOne = "\(minDist)"
    solution.partTwo = "\(minDelay)"
    return solution
}

//
//  day17.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay17 = true

enum Shield {
    case scaffold
    case space
}

func day17 (_ input:String) -> Solution {
    var solution = Solution()
    Direction.defaultOrigin = .topLeft
    
    let prog = Intcode(string: input)
    let _ = prog.run()
    
    var width = 0
    var lineSize = 0
    var height = 0
    for char in prog.output {
        if char == 10 {
            if lineSize > width {
                width = lineSize
            }
            lineSize = 0
            height += 1
        } else {
            lineSize += 1
        }
        
    }
    
    var nextPos = Point(0,0)
    let area = Area(at: nextPos, w: width, h: height)
    let grid = FiniteGrid(defaultValue: Shield.space, area: area)
    var robot = nextPos
    
    for char in prog.output {
        switch char {
        case 35: // #
            grid[nextPos] = .scaffold
        case 46: // .
            grid[nextPos] = .space
        case 60, 62, 94, 118: // < > ^ v
            grid[nextPos] = .scaffold
            robot = nextPos
        case 10:
            nextPos = Point(-1, nextPos.y + 1)
        default:
            print("Unknown program output: \(char)")
            exit(1)
        }
        nextPos = nextPos.move(.east)
    }
    
    var intersections = [Point]()
    for p in area {
        let n = p.adjacents()
        if grid[p] == .scaffold &&
            (!area.contains(point:n[0]) || grid[n[0]] == .scaffold) &&
            (!area.contains(point:n[1]) || grid[n[1]] == .scaffold) &&
            (!area.contains(point:n[2]) || grid[n[2]] == .scaffold) &&
            (!area.contains(point:n[3]) || grid[n[3]] == .scaffold) {
            intersections.append(p)
        }
    }
    
    let sum = intersections.reduce(0) { (previous, this) in
        previous + this.x * this.y
    }
    
    solution.partOne = "\(sum)"
    
    
    
//    solution.partTwo = "\()"
    return solution
}

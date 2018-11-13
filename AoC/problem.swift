//
//  problem.swift
//  AoC
//
//  Created by Paul Landers on 11/8/18.
//

import Foundation

let problemDay = 3


func problem(_ input:String) -> Solution {
    var solution = Solution()
    
    var current = Point(x:0, y:0)
    var visited = Set(arrayLiteral: current)
    
    for char in input {
        switch char {
        case "^" :
            current = current.move(.north)
        case "v":
            current = current.move(.south)
        case ">":
            current = current.move(.east)
        case "<":
            current = current.move(.west)
        default:
            print("unexpected char: \(char)")
            return solution
        }
        visited.insert(current)
    }
    solution.partOne = String(visited.count)
    
    var santa = Point(x:0, y:0)
    var robot = Point(x:0, y:0)
    var santaNext = true
    visited = Set(arrayLiteral: santa)
    
    for char in input {
        var d = Direction.north
        switch char {
        case "^" :
            d = .north
        case "v":
            d = .south
        case ">":
            d = .east
        case "<":
            d = .west
        default:
            print("unexpected char: \(char)")
            return solution
        }
        
        if santaNext {
            santa = santa.move(d)
            visited.insert(santa)
        } else {
            robot = robot.move(d)
            visited.insert(robot)
        }
        
        santaNext = !santaNext
    }
    solution.partTwo = String(visited.count)
    
    return solution
}

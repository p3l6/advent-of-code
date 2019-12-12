//
//  day11.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay11 = false

func paint(startingColor: Int, program: String) -> InfiniteGrid<Bool> {
    var position = Point(0,0)
    var direction = Direction.north
    let painted = InfiniteGrid<Bool>(defaultValue: false)
    var halted = false
    let robot = Intcode(string: program)
    robot.addInput(startingColor)
    
    while !halted {
        robot.clearOutput()
        halted = robot.run()
        painted[position] = robot.output[0] == 1
        direction = robot.output[1] == 0 ? direction.left : direction.right
        position = position.move(direction)
        robot.addInput(painted[position] ? 1 : 0)
    }
    return painted
}

func day11 (_ input:String) -> Solution {
    var solution = Solution()
    Direction.defaultOrigin = .topLeft
    
    var painted = paint(startingColor: 0, program:input)
    solution.partOne = "\(painted.grid.count)"
    
    painted = paint(startingColor: 1, program:input)
    print(painted.stringBy{$0 ? "X" : " " })
    
    // part two manually read from output
    solution.partTwo = "GREJALPR"
    return solution
}

//
//  day13.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay13 = false

enum TileId :Int {
    case empty = 0
    case wall = 1
    case block = 2
    case paddle = 3
    case ball = 4
}

func day13 (_ input:String) -> Solution {
    var solution = Solution()
    Direction.defaultOrigin = .topLeft
    
    let game = Intcode(string: input)
    let _ = game.run()
    
    var i = 0
    var blocks = 0
    while i < game.output.count - 2 {
        i += 3
        if TileId(rawValue: game.output[i+2]) == .block {
            blocks += 1
        }
    }
    
    solution.partOne = "\(blocks)"
    
    game.reset()
    game.modifyMem(at: 0, to: 2)
    
    var halted = false
    var score = 0
    while !halted {
        game.clearOutput()
        halted = game.run()
        
        var ballX = 0
        var paddleX = 0
        var i = 0
        while i < game.output.count - 2 {
            let x = game.output[i]
            if x < 0 {
                score = game.output[i+2]
            } else {
                let id = TileId(rawValue: game.output[i+2])
                if id == .ball {
                    ballX = x
                } else if id == .paddle {
                    paddleX = x
                }
            }
            i += 3
        }
        if paddleX == ballX { game.addInput(0) }
        if paddleX <  ballX { game.addInput(1) }
        if paddleX >  ballX { game.addInput(-1) }
    }
    
    solution.partTwo = "\(score)"
    return solution
}

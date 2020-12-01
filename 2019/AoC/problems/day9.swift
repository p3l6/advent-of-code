//
//  day9.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay9 = false

func day9 (_ input:String) -> Solution {
    var solution = Solution()
    let prog = Intcode(string: input)
    prog.addInput(1)
    let _ = prog.run()
    solution.partOne = "\(prog.output.last!)"
    
    prog.reset()
    prog.addInput(2)
    let _ = prog.run()
    solution.partTwo = "\(prog.output.last!)"
    return solution
}

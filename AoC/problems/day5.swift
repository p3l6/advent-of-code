//
//  day5.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay5 = true

func day5 (_ input:String) -> Solution {
    var solution = Solution()
    
    let program = Intcode(string:input)
    program.addInput(1)
    let _ = program.run()
    let diagnosticCode = program.output.last!
    
    solution.partOne = "\(diagnosticCode)"
//    solution.partTwo = "\()"
    return solution
}

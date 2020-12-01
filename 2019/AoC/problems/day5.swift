//
//  day5.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay5 = false

func day5 (_ input:String) -> Solution {
    var solution = Solution()
    
    let program = Intcode(string:input)
    program.addInput(1)
    let _ = program.run()
    let diagnosticCode = program.output.last!
    
    solution.partOne = "\(diagnosticCode)"
    
    let programRadiator = Intcode(string:input)
    programRadiator.addInput(5)
    let _ = programRadiator.run()
    let diagnosticCodeRadiator = programRadiator.output.last!
    
    solution.partTwo = "\(diagnosticCodeRadiator)"
    
    return solution
}

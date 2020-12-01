//
//  day2.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay2 = false

func day2 (_ input:String) -> Solution {
    var solution = Solution()
    
    var modifiedInput = input.integerArray(",")
    modifiedInput[1] = 12
    modifiedInput[2] = 2
    solution.partOne = "\(intcodeProg(modifiedInput))"
    
    both: for noun in 0...99 {
        for verb in 0...99 {
            var modifiedInput = input.integerArray(",")
            modifiedInput[1] = noun
            modifiedInput[2] = verb
            if intcodeProg(modifiedInput) == 19690720 {
                solution.partTwo = "\(100 * noun + verb)"
                break both
            }
        }
    }
    
    return solution
}

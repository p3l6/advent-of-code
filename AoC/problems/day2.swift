//
//  day2.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay2 = false

func intCodeProg(_ program: [Int]) -> Int {
    enum OpCode: Int {
        case Add = 1
        case Mult = 2
        case Halt = 99
    }
    var prog = program
    var pc = 0
    while prog[pc] != OpCode.Halt.rawValue {
        let a = prog[prog[pc+1]]
        let b = prog[prog[pc+2]]
        let outPos = prog[pc+3]
        switch prog[pc] {
        case OpCode.Add.rawValue:
            prog[outPos] = a + b
        case OpCode.Mult.rawValue:
            prog[outPos] = a * b
        default:
            print("Unexpected opcode")
            exit(1)
        }
        pc += 4
    }
    return prog.first!
}

func day2 (_ input:String) -> Solution {
    var solution = Solution()
    
    var modifiedInput = input.integerArray(",")
    modifiedInput[1] = 12
    modifiedInput[2] = 2
    solution.partOne = "\(intCodeProg(modifiedInput))"
    
    both: for noun in 0...99 {
        for verb in 0...99 {
            var modifiedInput = input.integerArray(",")
            modifiedInput[1] = noun
            modifiedInput[2] = verb
            if intCodeProg(modifiedInput) == 19690720 {
                solution.partTwo = "\(100 * noun + verb)"
                break both
            }
        }
    }
    
    return solution
}

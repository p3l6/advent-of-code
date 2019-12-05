//
//  computer.swift
//  AoC
//
//  Created by Paul Landers on 12/2/19.
//

import Foundation

class Intcode {
    enum OpCode: Int {
        case Add = 1
        case Mult = 2
        case Halt = 99
    }
    
    var prog :[Int]
    var ip = 0
    
    init(program: [Int]) {
        self.prog = program
    }
    
    func run() -> Int {
        while prog[ip] != OpCode.Halt.rawValue {
            let a = prog[prog[ip+1]]
            let b = prog[prog[ip+2]]
            let outPos = prog[ip+3]
            switch prog[ip] {
            case OpCode.Add.rawValue:
                prog[outPos] = a + b
            case OpCode.Mult.rawValue:
                prog[outPos] = a * b
            default:
                print("Unexpected opcode")
                exit(1)
            }
            ip += 4
        }
        return prog.first!
    }
}

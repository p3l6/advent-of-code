//
//  computer.swift
//  AoC
//
//  Created by Paul Landers on 12/2/19.
//

import Foundation

func intcodeProg(_ program: [Int]) -> Int {
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

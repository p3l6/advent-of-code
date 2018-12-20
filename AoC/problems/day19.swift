//
//  day19.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay19 = true

func day19 (_ input:String) -> Solution {
    
    var state = DeviceState(registers:[0,0,0,0,0,0])
    let ipIndex = input.lines().first!.extract(format: "#ip %")!.first!
    let program = input.lines()[1...].map { line -> (OpCode,Int,Int,Int) in
        var op = OpCode.unknown
        switch line.substring(toIndex: 4){
        case "addr": op = .addr
        case "addi": op = .addi
        case "mulr": op = .mulr
        case "muli": op = .muli
        case "banr": op = .banr
        case "bani": op = .bani
        case "borr": op = .borr
        case "bori": op = .bori
        case "setr": op = .setr
        case "seti": op = .seti
        case "gtir": op = .gtir
        case "gtri": op = .gtri
        case "gtrr": op = .gtrr
        case "eqir": op = .eqir
        case "eqri": op = .eqri
        case "eqrr": op = .eqrr
        default: assertionFailure("unreadable line: \(line)")
        }
        let ints = line.substring(fromIndex: 4).integerArray(" ")
        return (op, ints[0], ints[1], ints[2])
    }
    
    var ip = state.registers[ipIndex]
    while ip < program.count {
        let op = program[ip]
        state = state.stateBySettingRegister(at: ipIndex, to: ip)
        state = state.perform(opCode: op.0, inputs: (op.1,op.2), output: op.3)
        ip = state.registers[ipIndex]
        ip += 1
    }
    
    
    var solution = Solution()
    solution.partOne = "\(state.registers[0])"
    
    state = DeviceState(registers:[1,0,0,0,0,0])
    ip = state.registers[ipIndex]
    while ip < program.count {
        let op = program[ip]
        state = state.stateBySettingRegister(at: ipIndex, to: ip)
        state = state.perform(opCode: op.0, inputs: (op.1,op.2), output: op.3)
        ip = state.registers[ipIndex]
        ip += 1
    }
    
    solution.partTwo = "\(state.registers[0])"
    return solution
}

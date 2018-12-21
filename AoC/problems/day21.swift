//
//  day21.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay21 = false

// manually disassembled again
// this function runs for ever, but "eventually" stops printing codes, and the last one's the answer to part 2
// the argument is how many repeats in a row to get before giving up
func lastHalt(after:Int) -> Int {
    var d=0, f=0
    var codes = Set<Int>()
    var lastCode = 0
    var repeatCodes = 0
    
    while true {
        d = f | 0x10000
        f = 10828530
        
        while true {
            f = (f + (d & 0xFF)) & 0xFFFFFF
            f = (f * 65899) & 0xFFFFFF
            if d < 256 {
                if codes.contains(f) {
                    repeatCodes += 1
                    if repeatCodes > after { return lastCode }
                } else {
//                    print("new haltCode: \(f)")
                    repeatCodes = 0
                    codes.insert(f)
                    lastCode = f
                }
                break
            }
            d = d / 256
        }
    }
}

func day21 (_ input:String) -> Solution {

    var solution = Solution()
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
    
   
    state = DeviceState(registers:[0,0,0,0,0,0])
    var iCount = 0
    var ip = state.registers[ipIndex]
    while ip < program.count && iCount < 1_000_000 {
        let op = program[ip]
        state = state.stateBySettingRegister(at: ipIndex, to: ip)
        if ip == 28 { // the line where it checks the loop in my specific input
            solution.partOne = "\(state.registers[5])"
            break
        }
        state = state.perform(opCode: op.0, inputs: (op.1,op.2), output: op.3)
        ip = state.registers[ipIndex]
        ip += 1
        iCount += 1
    }
    
    solution.partTwo = "\(lastHalt(after:1))"
    
    return solution
}

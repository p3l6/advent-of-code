//
//  day16.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay16 = false

enum OpCode :CaseIterable {
    case unknown
    // Add
    case addr // r r r
    case addi // r v r
    // Mult
    case mulr // r r r
    case muli // r v r
    // Bitwise and
    case banr // r r r
    case bani // r v r
    // Bitwise or
    case borr // r r r
    case bori // r v r
    // assignment
    case setr // r _ r
    case seti // v _ r
    // greater than
    case gtir // va > rb ? rc=1 : rc=0
    case gtri // ra > vb ? rc=1 : rc=0
    case gtrr // ra > rb ? rc=1 : rc=0
    // equality
    case eqir // va == rb ? rc=1 : rc=0
    case eqri // ra == vb ? rc=1 : rc=0
    case eqrr // ra == rb ? rc=1 : rc=0
}

struct DeviceState :Equatable {
    static func == (lhs: DeviceState, rhs: DeviceState) -> Bool {
        return lhs.registers == rhs.registers
    }
    
    let registers :[Int]
    func perform(opCode:OpCode, inputs:(Int,Int), output:Int) -> DeviceState {
        var regs = registers
        switch opCode {
        case .unknown: assertionFailure()
        case .addr: regs[output] = regs[inputs.0] + regs[inputs.1]
        case .addi: regs[output] = regs[inputs.0] +      inputs.1
        case .mulr: regs[output] = regs[inputs.0] * regs[inputs.1]
        case .muli: regs[output] = regs[inputs.0] *      inputs.1
        case .banr: regs[output] = regs[inputs.0] & regs[inputs.1]
        case .bani: regs[output] = regs[inputs.0] &      inputs.1
        case .borr: regs[output] = regs[inputs.0] | regs[inputs.1]
        case .bori: regs[output] = regs[inputs.0] |      inputs.1
        case .setr: regs[output] = regs[inputs.0]
        case .seti: regs[output] =      inputs.0
        case .gtir: regs[output] =      inputs.0  > regs[inputs.1] ? 1 : 0
        case .gtri: regs[output] = regs[inputs.0] >      inputs.1  ? 1 : 0
        case .gtrr: regs[output] = regs[inputs.0] > regs[inputs.1] ? 1 : 0
        case .eqir: regs[output] =      inputs.0  == regs[inputs.1] ? 1 : 0
        case .eqri: regs[output] = regs[inputs.0] ==      inputs.1  ? 1 : 0
        case .eqrr: regs[output] = regs[inputs.0] == regs[inputs.1] ? 1 : 0
        }
        return DeviceState(registers: regs)
    }
    
    func stateBySettingRegister(at:Int, to:Int) -> DeviceState {
        var regs = registers
        regs[at] = to
        return DeviceState(registers: regs)
    }
}

struct Validator {
    let before :DeviceState
    let after :DeviceState
    let instruction :(Int,Int,Int,Int)
    func possibleOpCodes() -> [OpCode] {
        var possible = [OpCode]()
        for oc in OpCode.allCases {
            if oc == .unknown { continue }
            if after == before.perform(opCode: oc, inputs: (instruction.1,instruction.2), output: instruction.3) {
                possible.append(oc)
            }
        }
        return possible
    }
}

func day16 (_ input:String) -> Solution {
    var solution = Solution()
    let lines = input.lines()
    var validators = [Validator]()
    var nextLine = 0
    
    while true {
        guard let beforeInts = lines[nextLine].extract(format: "Before: [%,%,%,%]") else { break }
        nextLine += 1
        guard let instructionInts = lines[nextLine].extract(format: "% % % %")  else { break }
        nextLine += 1
        guard let afterInts = lines[nextLine].extract(format: "After:  [%,%,%,%]")  else { break }
        nextLine += 1
        let before = DeviceState(registers: beforeInts)
        let after = DeviceState(registers: afterInts)
        validators.append(Validator(before: before, after: after, instruction: (instructionInts[0],instructionInts[1],instructionInts[2],instructionInts[3])))
    }
    
    var moreThan3Possible = 0
    var realCodes = [OpCode](repeating: .unknown, count: 16)
    for v in validators {
        let possibilities = v.possibleOpCodes()
        if possibilities.count >= 3 {
            moreThan3Possible += 1
        } else if possibilities.count == 1 {
            realCodes[v.instruction.0] = possibilities.first!
        }
    }

    solution.partOne = "\(moreThan3Possible)"

    while realCodes.contains(.unknown) {
        for v in validators {
            let possibilities = v.possibleOpCodes().filter({!realCodes.contains($0)})
            if possibilities.count == 1 {
                realCodes[v.instruction.0] = possibilities.first!
            }
        }
    }
    
    var programState = DeviceState(registers: [0,0,0,0])
    for line in lines[nextLine...] {
        let inst = line.extract(format: "% % % %")!
        programState = programState.perform(opCode: realCodes[inst[0]], inputs: (inst[1],inst[2]), output: inst[3])
    }
    
    solution.partTwo = "\(programState.registers[0])"
    return solution
}

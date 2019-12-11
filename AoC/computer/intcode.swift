//
//  computer.swift
//  AoC
//
//  Created by Paul Landers on 12/2/19.
//

import Foundation

class Intcode {
    enum OpCode: Int {
                          // parameters
        case add    = 1   // a + b -> c
        case mult   = 2   // a * b -> c
        case input  = 3   // a
        case output = 4   // a
        case jmpT   = 5   // a ? ip
        case jmpF   = 6   // !a ? ip
        case less   = 7   // a < b ? 1 : 0 -> c
        case equal  = 8   // a == b ? 1 : 0 -> c
        case base   = 9   // a
        case halt   = 99  // --
        
        func length() -> Int { return self.params() + 1 }
        func params() -> Int {
            switch self {
            case .add, .mult, .less, .equal:
                return 3
            case .jmpT, .jmpF:
                return 2
            case .input, .output, .base:
                return 1
            case .halt:
                return 0
            }
        }
    }
    
    enum ParameterMode: Int {
        case position = 0
        case immediate = 1
        case relative = 2
    }
    
    private var prog: [Int]
    private let initialProg: [Int]
    private var extraMemory = [Int:Int]()
    private var ip = 0
    private var input = [Int]()
    private(set) var output = [Int]()
    private var relativeBase = 0
    
    init(program: [Int]) {
        self.prog = program
        self.initialProg = program
    }
    
    convenience init(string: String) {
        self.init(program:string.integerArray(","))
    }
    
    func addInput(_ x: Int) {
        self.input.append(x)
    }
    
    func reset() {
        ip = 0
        relativeBase = 0
        input.removeAll()
        output.removeAll()
        extraMemory.removeAll()
        prog = initialProg
    }
    
    private static func decodeInstruction(_ inst:Int) -> (code: OpCode, paramModes: [ParameterMode]) {
        let code = OpCode(rawValue: inst % 100)!
        var params = [ParameterMode]()
        var remain = inst / 100
        for _ in 0..<code.params() {
            params.append(ParameterMode(rawValue: remain % 10)!)
            remain /= 10
        }
        return (code, params)
    }
    
    /// Index for first param is 0
    private func param(_ index: Int, _ mode:ParameterMode = .immediate) -> Int {
        let value = prog[ip + 1 + index]
        
        switch mode {
        case .immediate:
            return value
        case .position:
            if value >= prog.count {
                return extraMemory[value] ?? 0
            }
            return prog[value]
        case .relative:
            let access = relativeBase + value
            if access >= prog.count {
                return extraMemory[access] ?? 0
            }
            return prog[access]
        }
    }
    
    private func write(_ index: Int, _ mode: ParameterMode, val: Int) {
        assert(mode != .immediate, "Writes should not be immediate!")
        let writeLoc = mode == .relative ? index + relativeBase : index
        
        if writeLoc >= prog.count {
            extraMemory[writeLoc] = val
        } else {
            prog[writeLoc] = val
        }
    }
    
    /// returns true if finished, false if input needed
    func run() -> Bool {
        while true {
            let (code, modes) = Intcode.decodeInstruction(prog[ip])
            
            switch code {
            case .add:
                write(param(2), modes[2], val: param(0, modes[0]) + param(1, modes[1]))
            case .mult:
                write(param(2), modes[2], val: param(0, modes[0]) * param(1, modes[1]))
            case .input:
                if input.isEmpty { return false }
                write(param(0), modes[0], val: input.removeFirst())
            case .output:
                output.append(param(0, modes[0]))
            case .jmpT:
                if param(0, modes[0]) != 0 {
                    ip = param(1, modes[1])
                    continue
                }
            case .jmpF:
                if param(0, modes[0]) == 0 {
                    ip = param(1, modes[1])
                    continue
                }
            case .less:
                write(param(2), modes[2], val: param(0, modes[0]) < param(1, modes[1]) ? 1 : 0)
            case .equal:
                write(param(2), modes[2], val: param(0, modes[0]) == param(1, modes[1]) ? 1 : 0)
            case .base:
                relativeBase += param(0, modes[0])
            case .halt:
                return true
            }
            
            ip += code.length()
        }
    }
}

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
        case Add    = 1   // a + b -> c
        case Mult   = 2   // a * b -> c
        case Input  = 3   // a
        case Output = 4   // a
        case Halt   = 99  // --
        
        func length() -> Int { return self.params() + 1 }
        func params() -> Int {
            switch self {
            case .Add, .Mult:
                return 3
            case .Input, .Output:
                return 1
            case .Halt:
                return 0
            }
        }
    }
    
    enum ParameterMode: Int {
        case Position = 0
        case Immediate = 1
    }
    
    private var prog :[Int]
    private var ip = 0
    private var input = [Int]()
    private(set) var output = [Int]()
    
    init(program: [Int]) {
        self.prog = program
    }
    
    convenience init(string: String) {
        self.init(program:string.integerArray(","))
    }
    
    func addInput(_ x: Int) {
        self.input.append(x)
    }
    
    private static func decodeInstruction(_ inst:Int) -> (code: OpCode, paramModes: [ParameterMode]) {
        let code = OpCode(rawValue: inst % 100)!
        var params = [ParameterMode]()
        var remain = inst / 100
        for _ in 0..<code.params() {
            params.append( remain % 10 == 0 ? ParameterMode.Position : ParameterMode.Immediate )
            remain /= 10
        }
        return (code, params)
    }
    
    /// Index for first param is 0
    private func param(_ index: Int, _ mode:ParameterMode = .Immediate) -> Int {
        switch mode {
        case .Immediate: return prog[ip + 1 + index]
        case .Position: return prog[prog[ip + 1 + index]]
        }
    }
    
    /// returns true if finished, false if input needed
    func run() -> Bool {
        while true {
            let (code, modes) = Intcode.decodeInstruction(prog[ip])
            
            // instructions with writes will always write to position mode
            
            switch code {
            case .Add:
                prog[param(2)] = param(0, modes[0]) + param(1, modes[1])
            case .Mult:
                prog[param(2)] = param(0, modes[0]) * param(1, modes[1])
            case .Input:
                if input.isEmpty { return false }
                prog[param(0)] = input.removeFirst()
            case .Output:
                output.append(param(0, modes[0]))
            case .Halt:
                return true
            }
            
            ip += code.length()
        }
    }
}

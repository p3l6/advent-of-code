
import Foundation

let runDay8 = false

class Gameboy {
    struct Instruction {
        enum Operation: String {
            case nop
            case acc
            case jmp
        }
        let op: Operation
        let arg: Int
    }
    let prog: [Instruction]
    var lineExecutions: [Int]
    var pc = 0
    var register = 0
    
    init(prog: [Instruction]) {
        self.prog = prog
        self.lineExecutions = Array(repeating: 0, count: prog.count)
    }
    
    /// Returns true for a normal termination
    func run() -> Bool {
        while pc < prog.count && lineExecutions[pc] == 0 {
            lineExecutions[pc] += 1
            switch prog[pc].op {
            case .nop: pc += 1
            case .acc:
                register += prog[pc].arg
                pc += 1
            case .jmp:
                pc += prog[pc].arg
            }
        }
        return pc == prog.count
    }
}

func day8 (_ input:String) -> Solution {
    var solution = Solution()
    let instructions: [Gameboy.Instruction] = input.lines().map { line in
        let parts = line.stringArray(" ")
        return Gameboy.Instruction(op: Gameboy.Instruction.Operation(rawValue: parts[0])!, arg: Int(parts[1])!)
    }
    
    let game = Gameboy(prog: instructions)
    let _ = game.run()
    
    solution.partOne = "\(game.register)"
    
    for (idx, inst) in instructions.enumerated() {
        if inst.op == .acc { continue }
        let newInst = Gameboy.Instruction(op: inst.op == .nop ? .jmp : .nop, arg: inst.arg)
        var newInstructions = instructions
        newInstructions[idx] = newInst
        let game = Gameboy(prog: newInstructions)
        if game.run() {
            solution.partTwo = "\(game.register)"
            break
        }
    }

    return solution
}


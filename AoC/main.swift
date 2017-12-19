//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input =  puzzleInput
"""
set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2
"""

class Program {
    var pc = 0
    var registers = ["p":0]
    var receivedMessages = [Int]()
    var deliverTo :Program?
    var sentMessages = 0
    
    let program : [(inst:String, reg:String, val:String?)]  = input.split(separator: "\n").map { line in
        let p = line.split(separator: " ")
        return (inst:String(p[0]), reg:String(p[1]), val:(p.count>2 ? String(p[2]) : nil))
    }

    var isWaiting :Bool { return program[pc].inst == "rcv" && receivedMessages.isEmpty }

    init(number:Int) {
        registers["p"] = number
    }
    
    func value(_ xIn:String?) -> Int {
        guard let x = xIn else {
            return 0
        }
        return Int(x) ?? registers[x] ?? 0
    }
    
    func receive(_ x:Int) {
        receivedMessages.append(x)
    }
    
    func runProgram() {
        programLoop: while true {
            let prog = program[pc]
            switch prog.inst {
            case "snd":
                deliverTo?.receive(value(prog.reg))
                sentMessages += 1
            case "set":
                registers[prog.reg] = value(prog.val)
            case "add":
                registers[prog.reg] = value(prog.reg) + value(prog.val)
            case "mul":
                registers[prog.reg] = value(prog.reg) * value(prog.val)
            case "mod":
                registers[prog.reg] = value(prog.reg) % value(prog.val)
            case "rcv":
                if !receivedMessages.isEmpty {
                    registers[prog.reg] = receivedMessages.removeFirst()
                } else { break programLoop }
            case "jgz":
                if value(prog.reg) > 0 {
                    pc += value(prog.val)
                    pc -= 1 // don't increase pc
                }
            default:
                break
            }
            pc+=1
        }
    }
}

let prog  = Program(number:0)
let output = Program(number:42)
prog.deliverTo = output
prog.runProgram()
print("part one: \(output.receivedMessages.last!)") // 3423

let prog0 = Program(number:0)
let prog1 = Program(number:1)
prog0.deliverTo = prog1
prog1.deliverTo = prog0

while !(prog0.isWaiting && prog1.isWaiting){
    prog0.runProgram()
    prog1.runProgram()
}

print("part two: \(prog1.sentMessages)") // 7493

execTime.end()

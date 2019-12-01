//
//  day19.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay19 = false

func elf2c(elf:String) -> String {
    func basicOp(_ names:[String], _ ints:[Int], _ op:String, _ i:Bool ) -> String {
        if op.isEmpty {
             return "\(names[ints[2]]) = \(i ? String(ints[0]) : names[ints[0]])"
        } else if ints[0] == ints[2] {
             return "\(names[ints[2]]) \(op)= \(i ? String(ints[1]) : names[ints[1]])"
        } else if !i && ints[1] == ints[2] {
            return "\(names[ints[2]]) \(op)= \(names[ints[0]])"
        } else {
            return "\(names[ints[2]]) = \(names[ints[0]]) \(op) \(i ? String(ints[1]) : names[ints[1]])"
        }
    }
    func conditionOp(_ names:[String], _ ints:[Int], _ op:String, _ i0:Bool, _ i1:Bool ) -> String {
        return "\(names[ints[2]]) = (\(i0 ? String(ints[0]) : names[ints[0]]) \(op) \(i1 ? String(ints[1]) : names[ints[1]]))"
    }
    
    var cProg = [String]()
    let ipIndex = elf.lines().first!.extract(format: "#ip %")!.first!
    var regNames = ["a","b","c","d","e","f"]
    regNames[ipIndex] = "i_p"
    for line in elf.lines()[1...] {
        let ints = line.substring(fromIndex: 4).integerArray(" ")
        
        switch line.substring(toIndex: 4){
        case "addr": cProg.append(basicOp(regNames, ints, "+", false))
        case "addi": cProg.append(basicOp(regNames, ints, "+", true))
        case "mulr": cProg.append(basicOp(regNames, ints, "*", false))
        case "muli": cProg.append(basicOp(regNames, ints, "*", true))
        case "banr": cProg.append(basicOp(regNames, ints, "&", false))
        case "bani": cProg.append(basicOp(regNames, ints, "&", true))
        case "borr": cProg.append(basicOp(regNames, ints, "|", false))
        case "bori": cProg.append(basicOp(regNames, ints, "|", true))
        case "setr": cProg.append(basicOp(regNames, ints, "", false))
        case "seti": cProg.append(basicOp(regNames, ints, "", true))
        case "gtir": cProg.append(conditionOp(regNames, ints, ">", true, false))
        case "gtri": cProg.append(conditionOp(regNames, ints, ">", false, true))
        case "gtrr": cProg.append(conditionOp(regNames, ints, ">", false, false))
        case "eqir": cProg.append(conditionOp(regNames, ints, "==", true, false))
        case "eqri": cProg.append(conditionOp(regNames, ints, "==", false, true))
        case "eqrr": cProg.append(conditionOp(regNames, ints, "==", false, false))
        default: assertionFailure("unreadable line: \(line)")
        }
    }
    // replace ip right of equals with value
    cProg = cProg.map { $0.hasPrefix("i_p") ? "ip" + $0.substring(fromIndex: 3) : $0 }
    cProg = cProg.enumerated().map { (i,str) in str.replacingOccurrences(of: "i_p", with: String(i)) }
    // identify goto's
    var label = 1
    for (num, line) in cProg.enumerated() {
        var nextIp = line.extract(format: "ip = %")?.first
        if nextIp == nil { if let offset = line.extract(format: "ip += %")?.first { nextIp = offset + num } }
        if nextIp != nil {
            let nextLine = nextIp! + 1
            cProg[num] = "goto label_\(label)"
            if nextLine < cProg.count {
                cProg[nextLine] = "label_\(label):\n\(cProg[nextLine])"
            } else {
                cProg[nextLine] = "exit"
            }
            label += 1
        }
    }
    // identify if/else
    
    // prepend register init, some // ------ at end and beginning
    let borders = "// ------- Generated code --------"
    cProg.insert(borders, at: 0)
    cProg.append(borders)
    return cProg.joined(separator: "\n")
}

func sumOfDivisors(_ f:Int) -> Int {
    var a = 0
    for x in 1...f {
        if f == (f/x) * x {
            a += x
        }
    }
    return a
}

func day19 (_ input:String) -> Solution {
    var solution = Solution()
    print(elf2c(elf: input))
    
    // This algorithm and inputs were found by manually "disassembling" the input on paper!
    solution.partOne = "\(sumOfDivisors(836 + 119))"
    solution.partTwo = "\(sumOfDivisors(836 + 119 + ((27*28)+29)*30*14*32))"
    return solution
}

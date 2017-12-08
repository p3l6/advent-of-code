//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input = puzzleInput
"""
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
"""

var registers : [String:Int] = [:]

func valOf(_ reg:String) -> Int {
    if registers[reg] == nil {
        registers[reg] = 0
    }
    return registers[reg]!
}

var maxValDuring = 0

for line in input.split(separator: "\n") {
    let elements = line.split(separator: " ")
    let reg = String(elements[0])
    let increase = elements[1] == "inc"
    let diff = Int(elements[2])!
    let compReg = String(elements[4])
    let compOp = String(elements[5])
    let compVal = Int(elements[6])!
    
    
    switch compOp {
    case ">" where valOf(compReg) > compVal: fallthrough
    case "<" where valOf(compReg) < compVal: fallthrough
    case ">=" where valOf(compReg) >= compVal: fallthrough
    case "<=" where valOf(compReg) <= compVal: fallthrough
    case "==" where valOf(compReg) == compVal: fallthrough
    case "!=" where valOf(compReg) != compVal:
        let _ = valOf(reg) // make sure it has a value
        registers[reg]! += (increase ? 1 : -1) * diff
        maxValDuring = max(maxValDuring, registers[reg]!)
    default:
        break
    }
}

//find max
var maxVal = 0
for val in registers.values { maxVal = max(maxVal, val) }

print("part one: \(maxVal)") // 6012
print("part two: \(maxValDuring)") // 6369

execTime.end()

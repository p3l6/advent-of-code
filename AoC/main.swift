//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input = puzzleInput
"""
0
3
0
1
-3
"""

var jumps = input.integerArray("\n")
var pc = 0
var stepCount = 0

while  0 <= pc && pc < jumps.count {
    //print("pc:\(pc) | \(jumps)")
    let jump = jumps[pc]
    jumps[pc] += 1
    pc += jump
    stepCount += 1
}
print("part one: \(stepCount)") // 358309

jumps = input.integerArray("\n")
pc = 0
stepCount = 0

while  0 <= pc && pc < jumps.count {
    //print("pc:\(pc) | \(jumps)")
    let jump = jumps[pc]
    jumps[pc] += (jump>=3 ? -1 : 1)
    pc += jump
    stepCount += 1
}
print("part two: \(stepCount)") // 28178177

execTime.end()

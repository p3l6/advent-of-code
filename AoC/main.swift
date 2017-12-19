//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input =   376 // puzzleInput

var buffer = [0]
var position = 0

for x in 1...2017 {
    position = ( position + input ) % buffer.count
    
    if position+1 == buffer.count {
        buffer.append(x)
    } else {
        buffer.insert(x, at: position+1)
    }

    position += 1
}

print("part one: \(buffer[position+1])") // 777

position = 0
var result  = 0


for x in 1...50_000_000 {
    // x is the length of the buffer...
    position = ( position + input ) % x
    
    if position == 0 {
        result = x
    }
    
    position += 1
}

print("part two: \(result)") // 39289581

execTime.end()

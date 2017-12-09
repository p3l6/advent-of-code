//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input =  puzzleInput
"""
"""

var scoreSum = 0
var nestLevel = 0
var skip = false
var inGarbage = false
var garbCount = 0

for char in input{
    if skip {
        skip = false
        continue
    }
    
    switch char {
    case "!":
        skip = true
    case "{" where !inGarbage:
        nestLevel += 1
    case "}" where !inGarbage:
        scoreSum += nestLevel
        nestLevel -= 1
    case "<" where !inGarbage:
        inGarbage = true
    case ">" where inGarbage:
        inGarbage = false
    default:
        if inGarbage {
            garbCount+=1
        }
        break
    }
}

print("part one: \(scoreSum)") // 10820
print("part two: \(garbCount)") // 5547

execTime.end()

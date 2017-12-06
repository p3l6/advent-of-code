//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input = puzzleInput
"""
0 2 7 0
"""

var banks = input.integerArray(" ")

func redistribute(_ list :[Int] ) -> [Int] {
    var maxIndex = 0
    for (index,item) in list.enumerated() {
        if item > list[maxIndex] {
            maxIndex = index
        }
    }
    var output = list
    var dist = list[maxIndex]
    output[maxIndex] = 0
    while dist > 0 {
        maxIndex+=1
        maxIndex = maxIndex % output.count
        output[maxIndex] += 1
        dist -= 1
    }
    return output
}

var state = banks
var visited :Set<String> = []
var redistributions = 0
repeat {
    visited.insert(state.description)

    state = redistribute(state)
    redistributions += 1
} while !visited.contains(state.description)

print("part one: \(redistributions)") // 6681

redistributions = 0
let wanted = state.description
repeat {
    state = redistribute(state)
    redistributions += 1
} while wanted != state.description

print("part two: \(redistributions)") // 2392
execTime.end()

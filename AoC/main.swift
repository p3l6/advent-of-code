//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input = puzzleInput

let maxVal = 255

var values = Array<Int>(0...maxVal)
var skipSize = 0
var currentIndex = 0

func knot(values:inout [Int], currentIndex: inout Int, lengths:[Int]) {
    for length in lengths {
        let prevValues = values
        for i in 0 ..< length {
            values[(i+currentIndex)%(maxVal+1)] = prevValues[(currentIndex+length-i-1)%(maxVal+1)]
        }
        currentIndex += length+skipSize
        skipSize += 1
    }
}


knot(values: &values, currentIndex: &currentIndex, lengths:input.integerArray(",") )

print("part one: \(values[0]*values[1])") // 40132

values = Array<Int>(0...maxVal)
skipSize = 0
currentIndex = 0

var lengths = input.utf8.map({Int($0)})
lengths += [17, 31, 73, 47, 23]
for _ in 0..<64 {
    knot(values: &values, currentIndex: &currentIndex, lengths: lengths)
}

let sparseHash = values
var hash = ""
for i in 0..<16 {
    var denseElem = sparseHash[i*16+0]
    for j in 1..<16 {
       denseElem ^= sparseHash[i*16+j]
    }
    hash += String(format:"%02x", denseElem)
}

print("part two: \(hash)") // 35b028fe2c958793f7d5a61d07a008c8

execTime.end()

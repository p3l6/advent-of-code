//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input =   "oundnydw" // puzzleInput
"""
flqrgnkx
"""


func knotHash(input:String) -> [Bool] {
    let maxVal = 255
    var skipSize = 0
    var currentIndex = 0
    var values = Array<Int>(0...maxVal)
    var lengths = input.utf8.map({Int($0)})
    lengths += [17, 31, 73, 47, 23]
    for _ in 0..<64 {
        for length in lengths {
            let prevValues = values
            for i in 0 ..< length {
                values[(i+currentIndex)%(maxVal+1)] = prevValues[(currentIndex+length-i-1)%(maxVal+1)]
            }
            currentIndex += length+skipSize
            skipSize += 1
        }
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
    
    var bools = [Bool]()
    for char in hash {
        switch char {
        case "0":  bools += [false, false, false, false]
        case "1":  bools += [false, false, false, true ]
        case "2":  bools += [false, false, true , false]
        case "3":  bools += [false, false, true , true ]
        case "4":  bools += [false, true , false, false]
        case "5":  bools += [false, true , false, true ]
        case "6":  bools += [false, true , true , false]
        case "7":  bools += [false, true , true , true ]
        case "8":  bools += [true , false, false, false]
        case "9":  bools += [true , false, false, true ]
        case "a":  bools += [true , false, true , false]
        case "b":  bools += [true , false, true , true ]
        case "c":  bools += [true , true , false, false]
        case "d":  bools += [true , true , false, true ]
        case "e":  bools += [true , true , true , false]
        case "f":  bools += [true , true , true , true ]
        default:
            break
        }
    }
    return bools
}

var rows = [[Bool]]()
var used = 0
for i in 0..<128 {
    rows.append(knotHash(input: input+"-"+String(i)))
    rows.last!.forEach { if $0 {used += 1 } }
}

print("part one: \(used)") // 8106

struct Point {
    var row :Int
    var col :Int
}

func findUsedBlock() -> Point? {
    for i in 0..<rows.count {
        if let col = rows[i].index(of:true) {
            return Point(row:i, col:col)
        }
    }
    return nil
}

func removeRegion(at:Point) {
    var toRemove = Stack<Point>()
    toRemove.push(at)
    while !toRemove.isEmpty {
        let r = toRemove.pop()
        rows[r.row][r.col] = false
        if r.row+1 < 128 && rows[r.row+1][r.col]  { toRemove.push(Point(row:r.row+1, col:r.col)) }
        if r.row-1 >= 0  && rows[r.row-1][r.col]  { toRemove.push(Point(row:r.row-1, col:r.col)) }
        if r.col+1 < 128 && rows[r.row][r.col+1]  { toRemove.push(Point(row:r.row, col:r.col+1)) }
        if r.col-1 >= 0  && rows[r.row][r.col-1]  { toRemove.push(Point(row:r.row, col:r.col-1)) }
    }
}

var regions = 0
while let location = findUsedBlock() {
    removeRegion(at: location)
    regions += 1
}

print("part two: \(regions)") // 1164

execTime.end()

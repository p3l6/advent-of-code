//
//  day8.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay8 = false

func sumMeta(_ ints: [Int]) -> (meta: Int, size: Int, value: Int) {
    let childCount = ints[0]
    let metaCount = ints[1]
    var metaSum = 0
    var size = 2
    var value = 0
    var childrenValues = [Int]()
    for _ in 0..<childCount {
        let child = sumMeta(Array<Int>(ints[size...]))
        size += child.size
        metaSum += child.meta
        childrenValues.append(child.value)
    }
    metaSum += ints[size..<size+metaCount].reduce(0,+)
    if childCount == 0 {
        value = metaSum
    } else {
        for meta in ints[size..<size+metaCount] {
            if meta > 0 && meta-1 < childrenValues.count {
                value += childrenValues[meta-1]
            }
        }
    }
    size += metaCount
    return (metaSum, size, value)
}

func day8 (_ input:String) -> Solution {
    var solution = Solution()
    
    let ints = input.integerArray(" ")
    let (meta, size, value) = sumMeta(ints)
    assert(size == ints.count)
    solution.partOne = "\(meta)"
    solution.partTwo = "\(value)"
    
    return solution
}

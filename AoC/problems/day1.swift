//
//  day1.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay1 = false

func day1 (_ input:String) -> Solution {
    var solution = Solution()
    
    let ints = input.integerArray("\n")
    var freq = 0
    
    for i in ints {
        freq += i
    }
    solution.partOne = "\(freq)"
    
    freq = 0
    var freqs = Set<Int>()
    all: while true {
        for i in ints {
            freq += i
            if freqs.contains(freq) {
                solution.partTwo = "\(freq)"
                break all
            }
            freqs.insert(freq)
        }
    }
    return solution
}

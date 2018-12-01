//
//  problem.swift
//  AoC
//
//  Created by Paul Landers on 11/8/18.
//

import Foundation

let problemDay = 1

// gotchas: input in examples was separated differently than actual , vs \n
//          some of the examples for part one produced infinite loops in part two

func problem(_ input:String) -> Solution {
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

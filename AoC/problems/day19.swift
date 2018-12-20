//
//  day19.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay19 = false

func sumOfDivisors(_ f:Int) -> Int {
    var a = 0
    for x in 1...f {
        if f == (f/x) * x {
            a += x
        }
    }
    return a
}

func day19 (_ input:String) -> Solution {
    var solution = Solution()
    
    // This algorithm and inputs were found by manually "disassembling" the input on paper!
    solution.partOne = "\(sumOfDivisors(836 + 119))"
    solution.partTwo = "\(sumOfDivisors(836 + 119 + ((27*28)+29)*30*14*32))"
    return solution
}

//
//  day4.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay4 = false

func day4 (_ input:String) -> Solution {
    var solution = Solution()
    let min = input.integerArray("-")[0]
    let max = input.integerArray("-")[1]
    
    var possibles = [Int]()
    
    passLoop:
    for n in min..<max {
        let digits = n.digits()
        var last = 0
        var double = false
        for d in digits {
            if d < last {
                continue passLoop
            }
            if d == last {
                double = true
            }
            last = d
        }
        
        if !double {
            continue
        }
        
        possibles.append(n)
    }
    
    solution.partOne = "\(possibles.count)"
    
    var count = 0
    
    passLoop:
    for n in possibles {
        let digits = n.digits()
        var last = 0
        var runCount = 0
        var double = false
        for d in digits {
            if d == last {
                runCount += 1
            } else {
                if runCount == 2 {
                    double = true
                }
                runCount = 1
            }
            last = d
        }
        
        if runCount == 2 {
            double = true
        }
        
        if !double {
            continue
        }
        
        count += 1
    }
    
    solution.partTwo = "\(count)"
    return solution
}

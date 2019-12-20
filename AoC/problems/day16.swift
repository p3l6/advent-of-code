//
//  day16.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay16 = false

func processPhase(signal: [Int]) -> [Int] {
    var next = [Int]()
    
    let basePattern = [0,1,0,-1]
    
    for s in 0..<signal.count {
        var sum = 0
        
        for i in 0..<signal.count {
            let value = basePattern[ ((i+1)/(s+1)) % 4 ]
            switch value {
            case 1: sum += signal[i]
            case -1:  sum -= signal[i]
            default: continue
            }
        }
        next.append( abs(sum) % 10 )
    }
    
    return next
}

func day16 (_ input:String) -> Solution {
    var solution = Solution()
    
    let initial :[Int] = input.map { Int(String($0))! }
    
    var signal = initial
    for _ in 0..<100 {
        signal = processPhase(signal:signal)
    }
    
    var first8 = ""
    for i in 0..<8 { first8.append(String(signal[i])) }
    solution.partOne = "\(first8)"
    
    return solution
    // got the above down to 20s, but still way to slow
    // had it down to 3s by caching the pattern indexes, but had to drop that
    // because for part 2 it would take days to even build the cache.
    
    var first7 = ""
    for i in 0..<8 { first7.append(String(initial[i])) }
    let offset = Int(first7)!
    
    signal = [[Int]](repeating: initial, count: 10_000).flatMap{$0}
    
    for phase in 0..<100 {
        signal = processPhase(signal:signal)
    }
    
    first8 = ""
    for i in 0..<8 { first8.append(String(signal[offset+i])) }
    solution.partTwo = "\(first8)"
    
    return solution
}

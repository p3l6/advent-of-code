//
//  day16.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay16 = false

var patternCache = [Int:[Int]]()
func getPattern(forIndex: Int, atLeast: Int) -> [Int] {
    if let inCache = patternCache[forIndex] { return inCache }
    
    let basePattern = [0,1,0,-1]
    var expanded = [Int](repeating: 0, count: atLeast+1)
    for i in 0..<expanded.count {
        expanded[i] = basePattern[ (i/(forIndex+1)) % 4 ]
    }
    
    let _ = expanded.removeFirst()
    
    patternCache[forIndex] = expanded
    return expanded
}

func processPhase(signal: [Int]) -> [Int] {
    var next = [Int]()
    
    for s in 0..<signal.count {
        let pattern = getPattern(forIndex: s, atLeast: signal.count)
        var sum = 0
        for i in 0..<signal.count {
            sum += signal[i] * pattern[i]
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
    
    // above took 45 seconds, needs to be faster for part 2!
    
    // set initial signal
    // get offset of first seven digits
    // repeat signal 10_000 times
    
    // do 100 phases
    
    // read 8 digits at offset
    
//    solution.partTwo = "\()"
    return solution
}

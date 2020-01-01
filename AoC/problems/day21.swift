//
//  day21.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay21 = false

func summarize(_ output: String) {
    print("\njump error: ")
    for line in output.lines() {
        if line.contains("#") && line.contains("@") {
            print(line)
        }
    }
    print()
}

func day21 (_ input:String) -> Solution {
    var solution = Solution()
    let springDroid = Intcode(string: input)
    
//  J = (!A || !B || !C) && D
    let script = """
NOT A J
NOT B T
OR  T J
NOT C T
OR  T J
AND D J
WALK\n
"""
    springDroid.addAsciiInput(script)
    
    var finished = false
    while !finished { finished = springDroid.run() }
    
    if let damage = springDroid.output.last, damage > 255 {
        solution.partOne = "\(damage)"
    } else {
        summarize(springDroid.asciiOutput())
//        print(springDroid.asciiOutput())
    }
    
//  J = (!A || !B || !C)  && (E || H) && D
    let extendedScript = """
NOT A T
OR  T J
NOT B T
OR  T J
NOT C T
OR  T J
NOT A T
AND A T
OR  E T
OR  H T
AND T J
AND D J
RUN\n
"""
    springDroid.reset()
    springDroid.addAsciiInput(extendedScript)
    
    finished = false
    while !finished { finished = springDroid.run() }
    
    if let damage = springDroid.output.last, damage > 255 {
        solution.partTwo = "\(damage)"
    } else {
        print(springDroid.asciiOutput())
        summarize(springDroid.asciiOutput())
    }
    
    return solution
}

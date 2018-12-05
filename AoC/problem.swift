//
//  problem.swift
//  AoC
//
//  Created by Paul Landers on 11/8/18.
//

import Foundation

let problemDay = 5

func reacts(_ a: Character, _ b:Character) -> Bool {
    return a != b && a.lowerCase == b.lowerCase
}

func react(_ poly: [Character]) -> [Character] {
    var i = 0
    var polymer = poly
    while i+1 < polymer.count {
        if reacts(polymer[i],polymer[i+1]) {
            // all the time is spent removing these. A linked list would be much better
            polymer.remove(at: i)
            polymer.remove(at: i)
            i = max(i-1, 0)
        } else {
            i += 1
        }
    }
    return polymer
}

func problem(_ input:String) -> Solution {
    var solution = Solution()
    
    let initialPolymer = [Character](input)
    
    let polymer = react(initialPolymer)
    solution.partOne = "\(polymer.count)"
    
    var min = initialPolymer.count
    for c in "ABCDEFGHIJKLMNOPQRSTUVWXYZ" {
        var polymer = initialPolymer
        polymer.removeAll { (ch) -> Bool in return c == ch || ch == c.lowerCase }
        polymer = react(polymer)
        if polymer.count < min {
            min = polymer.count
        }
    }
    
    solution.partTwo = "\(min)"
    
    return solution
}

//
//  day5.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay5 = false

func reacts(_ a: Character, _ b:Character) -> Bool {
    return a != b && a.lowerCase == b.lowerCase
}

func react(_ polyIn: [Character]) -> [Character] {
    var polyOut = [Character]()
    for charIn in polyIn {
        if polyOut.isEmpty || !reacts(polyOut.last!,charIn) {
            polyOut.append(charIn)
        } else {
            polyOut.removeLast()
        }
    }
    return polyOut
}

func day5 (_ input:String) -> Solution {
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

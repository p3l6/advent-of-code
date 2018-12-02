//
//  problem.swift
//  AoC
//
//  Created by Paul Landers on 11/8/18.
//

import Foundation

let problemDay = 2

func problem(_ input:String) -> Solution {
    var solution = Solution()
    
    var twos = 0
    var threes = 0
    
    let boxes = input.lines()
    
    for box in boxes {
        var one = Set<Character>()
        var two = Set<Character>()
        var three = Set<Character>()
        var more = Set<Character>()
        for char in box {
            if more.contains(char) {
                continue
            } else if three.contains(char) {
                three.remove(char)
                more.insert(char)
            }else if two.contains(char) {
                two.remove(char)
                three.insert(char)
            }else if one.contains(char) {
                one.remove(char)
                two.insert(char)
            } else {
                one.insert(char)
            }
        }
        if two.count > 0 {
            twos += 1
        }
        if three.count > 0 {
            threes += 1
        }
    }
    
    solution.partOne = "\(twos * threes)"
    
    func diff(_ a: String, _ b: String) -> Int{
        if a.count != b.count {
            return max(a.count,b.count)
        }
        var diff = 0
        for i in 0..<a.count {
            if a[i] != b[i] {
                diff += 1
            }
        }
        return diff
    }
    
    func intersection(_ a: String, _ b: String) -> String {
        var inter = ""
        for i in 0..<a.count {
            if a[i] == b[i] {
                inter += a[i]
            }
        }
        return inter
    }
    
    all: for b in boxes {
        for a in boxes {
            if a == b {
                continue
            }
            if diff(a,b) == 1 {
                solution.partTwo = "\(intersection(a,b))"
                break all
            }
        }
    }
    
    return solution
}

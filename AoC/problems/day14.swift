//
//  day14.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay14 = false

func day14 (_ input:String) -> Solution {
    var solution = Solution()
    
    let after = Int(input)!
    var scoreboard = [3,7]
    var elf1 = 0
    var elf2 = 1
    
    while scoreboard.count < after + 10 {
        let value1 = scoreboard[elf1]
        let value2 = scoreboard[elf2]
        let sum = value1 + value2
        scoreboard.append(contentsOf: sum.digits())
        elf1 = (elf1 + value1 + 1) % scoreboard.count
        elf2 = (elf2 + value2 + 1) % scoreboard.count
    }
    
    solution.partOne = "\(scoreboard[after..<after+10].map({String($0)}).joined())"
    
    scoreboard = [3,7]
    elf1 = 0
    elf2 = 1
    let inputDigits = after.digits()
    let lastDigit = inputDigits.last!
    
    all: while true {
        let value1 = scoreboard[elf1]
        let value2 = scoreboard[elf2]
        let sum = value1 + value2
        for digit in sum.digits() {
            scoreboard.append(digit)
            if  digit == lastDigit && scoreboard.count >= inputDigits.count {
                var matching = true
                for i in 0..<inputDigits.count {
                    if scoreboard[scoreboard.count - inputDigits.count + i] != inputDigits[i] {
                        matching = false
                        break
                    }
                }
                if  matching {
                    break all
                }
            }
        }
        elf1 = (elf1 + value1 + 1) % scoreboard.count
        elf2 = (elf2 + value2 + 1) % scoreboard.count
    }
    
    solution.partTwo = "\(scoreboard.count - inputDigits.count)"
    return solution
}

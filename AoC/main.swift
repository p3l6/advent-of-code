//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input =  // puzzleInput
"""
Values:
Generator A starts with 277
Generator B starts with 349

Factors:
(generator A uses 16807; generator B uses 48271),

"""

let divisor = 2_147_483_647
let mask = 0xffff

class Generator {
    var value :Int
    let factor :Int
    init(startingValue:Int, factor:Int) {
        value = startingValue
        self.factor = factor
    }
    func nextValue() -> Int {
        let temp = value * factor
        value = temp % divisor
        return value
    }
}

func beJudgy(genA:Generator, genB:Generator, iterations:Int) -> Int {
    var judge = 0
    for _ in 0 ..< iterations {
        let a = genA.nextValue()
        let b = genB.nextValue()
        
        if (a&mask) == (b&mask) {
            judge += 1
        }
    }
    return judge
}

let j = beJudgy(genA: Generator(startingValue: 277, factor: 16807),
                genB: Generator(startingValue: 349, factor: 48271),
                iterations: 40_000_000)

print("part one: \(j)") // 592

class PickyGenerator:Generator {
    var multiple :Int
    init(startingValue:Int, factor:Int, multiple:Int) {
        self.multiple = multiple
        super.init(startingValue:startingValue, factor:factor)
    }
    
    override func nextValue() -> Int {
        var ret = super.nextValue()
        while ret%multiple != 0 { ret = super.nextValue() }
        return ret
    }
}

let p = beJudgy(genA: PickyGenerator(startingValue: 277, factor: 16807, multiple:4),
                genB: PickyGenerator(startingValue: 349, factor: 48271, multiple:8),
                iterations: 5_000_000)

print("part two: \(p)") // 320

execTime.end()

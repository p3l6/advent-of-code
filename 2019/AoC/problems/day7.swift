//
//  day7.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay7 = false

func runAmps(prog: [Int], phaseSettings: [Int]) -> Int {
    let ampA = Intcode(program: prog)
    let ampB = Intcode(program: prog)
    let ampC = Intcode(program: prog)
    let ampD = Intcode(program: prog)
    let ampE = Intcode(program: prog)

    ampA.addInput(phaseSettings[0])
    ampB.addInput(phaseSettings[1])
    ampC.addInput(phaseSettings[2])
    ampD.addInput(phaseSettings[3])
    ampE.addInput(phaseSettings[4])

    var halted = false
    while !halted {
        ampA.addInput(ampE.output.isEmpty ? 0 : ampE.output.last!)
        let _ = ampA.run()
        
        ampB.addInput(ampA.output.last!)
        let _ = ampB.run()
        
        ampC.addInput(ampB.output.last!)
        let _ = ampC.run()
        
        ampD.addInput(ampC.output.last!)
        let _ = ampD.run()
        
        ampE.addInput(ampD.output.last!)
        halted = ampE.run()
    }
    
    return ampE.output.last!
}

func permutations(_ arr: [Int]) -> [[Int]] {
    if arr.count == 1 { return [arr] }
    var perms = [[Int]]()
    for index in 0..<arr.count {
        let last = arr[index]
        var rest = arr
        let _ = rest.remove(at: index)
        for p in permutations(rest) {
            var toAdd = p
            toAdd.append(last)
            perms.append(toAdd)
        }
    }
    return perms
}

func day7 (_ input:String) -> Solution {
    var solution = Solution()
    let program = input.integerArray(",")
    
    var maxSignal = 0
    for phases in permutations([0,1,2,3,4]) {
        let signal = runAmps(prog: program, phaseSettings: phases)
        if signal > maxSignal {
            maxSignal = signal
        }
    }
    
    solution.partOne = "\(maxSignal)"
    
    maxSignal = 0
    for phases in permutations([5,6,7,8,9]) {
        let signal = runAmps(prog: program, phaseSettings: phases)
        if signal > maxSignal {
            maxSignal = signal
        }
    }
    
    solution.partTwo = "\(maxSignal)"
    return solution
}

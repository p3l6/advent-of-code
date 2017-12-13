//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input =  puzzleInput
"""
0: 3
1: 2
4: 4
6: 4
"""

class Layer {
    var range :Int
    var depth :Int
    
    var scanner = 0
    
    init(depth:Int,range:Int) {
        self.range = range
        self.depth = depth
    }
    
    func reset(time:Int) {
        scanner = time%(range*2-2)
        if scanner >= range {
            scanner = range - (scanner-range+2)
        }
    }
    
    func willCatch(delay:Int) -> Bool {
        reset(time:delay+depth)
        return scanner == 0
    }
}

var layers = [Int:Layer]()

for line in input.split(separator: "\n") {
    let c = String(line).integerArray(":")
    layers[c[0]] = Layer(depth:c[0], range:c[1])
}

func severity(departureTime:Int) -> (severity: Int, caught: Bool) {
    var severity = 0
    var caught = false
    
    for layer in layers.values {
        if layer.willCatch(delay: departureTime) {
            caught = true
            severity += layer.depth * layer.range
            if departureTime != 0 { return (0,caught)}
        }
    }
    
    return (severity, caught)
}


print("part one: \(severity(departureTime: 0).severity)") // 1624

for delay in 0... {
    if !severity(departureTime: delay).caught {
        print("part two: \(delay)") // 3923436
        break
    }
}

execTime.end()

//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input = puzzleInput

struct State {
    struct Ops {
        let write :Int
        let dIndex :Int
        let dState :String
    }
    let zero :Ops
    let one :Ops
}

let states = [
    "A":State(zero:State.Ops(write: 1, dIndex: +1, dState: "B"), one:State.Ops(write: 0, dIndex: -1, dState: "C")),
    "B":State(zero:State.Ops(write: 1, dIndex: -1, dState: "A"), one:State.Ops(write: 1, dIndex: +1, dState: "D")),
    "C":State(zero:State.Ops(write: 1, dIndex: +1, dState: "A"), one:State.Ops(write: 0, dIndex: -1, dState: "E")),
    "D":State(zero:State.Ops(write: 1, dIndex: +1, dState: "A"), one:State.Ops(write: 0, dIndex: +1, dState: "B")),
    "E":State(zero:State.Ops(write: 1, dIndex: -1, dState: "F"), one:State.Ops(write: 1, dIndex: -1, dState: "C")),
    "F":State(zero:State.Ops(write: 1, dIndex: +1, dState: "D"), one:State.Ops(write: 1, dIndex: +1, dState: "A")),
]
var state = "A"

var oneBits = Set<Int>()
var cursor = 0

for _ in 0 ..< 12919244 {
    let ops = oneBits.contains(cursor) ? states[state]!.one : states[state]!.zero
    
    if ops.write == 1 {
        oneBits.insert(cursor)
    } else {
        oneBits.remove(cursor)
    }
    
    cursor += ops.dIndex
    state = ops.dState
}


print("part one: \(oneBits.count)") // 4287
print("part two: N/A")  //

execTime.end()

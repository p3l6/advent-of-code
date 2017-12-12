//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input =  puzzleInput
"""
0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5
"""

var pipes = [[Int]]()

for line in input.split(separator: "\n") {
    pipes.append(line.split(separator: ">")[1].split(separator:",").map({Int($0.trimmingCharacters(in: .whitespaces))!}))
}

func connectedSet(ofElement e:Int) -> Set<Int> {
    var connected = Set<Int>()
    connected.insert(e)
    var connectQueue = [e]

    while !connectQueue.isEmpty {
        let x = connectQueue.popLast()!
        for con in pipes[x] {
            if !connected.contains(con) {
                connectQueue.insert(con, at: 0)
                connected.insert(con)
            }
        }
    }
    return connected
}

print("part one: \(connectedSet(ofElement: 0).count)") // 169

var groups = [Set<Int>]()
var remaining = Set(0..<pipes.count)

while !remaining.isEmpty {
    let g = connectedSet(ofElement: remaining.removeFirst())
    remaining.subtract(g)
    groups.append(g)
}

print("part two: \(groups.count)") // 179

execTime.end()

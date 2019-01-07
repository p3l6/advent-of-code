//
//  day7.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay7 = false


extension Graph where T:Comparable {
    func orderedValues() -> [T] {
        assert(nodes.count <= 26)
        var ordered = [T]()
        var availible :[Node] = entryNodes()
        while !availible.isEmpty {
            availible.sort { $0.value < $1.value }
            let next = availible.removeFirst()
            assert(!next.completed)
            next.completed = true
            ordered.append(next.value)
            availible.append(contentsOf: next.outputs.filter { $0.inputs.reduce(true, {$0 && $1.completed}) } )
        }
        return ordered
    }
    
    func timedAssembly() -> Int {
        var time = 0
        var workers = [(Int, Node?)](repeating: (0,nil), count: 5)
        var availible :[Node] = entryNodes()
        while true {
            var anyoneWorking = false
            for (worker,(finishTime,workNode)) in workers.enumerated() {
                if workNode != nil {
                    if finishTime == time {
                        workNode!.completed = true
                        availible.append(contentsOf: workNode!.outputs.filter { $0.inputs.reduce(true, {$0 && $1.completed}) } )
                        workers[worker] = (0,nil)
                    } else {
                        anyoneWorking = true
                    }
                }
                if ((workNode==nil || workNode!.completed) && !availible.isEmpty) {
                    availible.sort { $0.value < $1.value }
                    let next = availible.removeFirst()
                    assert(!next.completed)
                    workers[worker] = (time + 60 + Int((next.value as! String).first!.asciiValue - Character("A").asciiValue + 1),next)
                    anyoneWorking = true
                }
            }
            if !anyoneWorking {
                if availible.isEmpty {
                    break
                } else {
                    continue // skip time increment
                }
            }
            
            time += 1
        }
        return time
    }
}

func day7 (_ input:String) -> Solution {
    var solution = Solution()
    
    let graph = Graph<String>()
    
    for requirement in input.lines() {
        let before = requirement[5]
        let after = requirement[36]
        graph.addEdge(from: before, to: after)
    }
    
    solution.partOne = graph.orderedValues().joined()
    assert(solution.partOne.count <= 26)
    for node in graph.nodes.values { node.completed = false }
    let time = graph.timedAssembly()
    assert( time < (60+13)*26 ) // reasonable upper bound with only one worker
    solution.partTwo = "\(time)"
    
    return solution
}

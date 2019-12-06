//
//  day6.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay6 = false

func day6 (_ input:String) -> Solution {
    var solution = Solution()
    let lines = input.lines()
    let orbits = Graph<String>()
    
    for line in lines {
        let masses = line.stringArray(")")
        orbits.addEdge(from: masses[0], to: masses[1])
    }
    
    var totalOrbits = 0
    var depth = 0
    var toVisit = orbits.entryNodes()
    while !toVisit.isEmpty {
        let thisVisit = toVisit
        toVisit.removeAll()
        for node in thisVisit {
            if node.completed { print("ERROR: node visited twice!") }
            node.completed = true
            totalOrbits += depth
            toVisit.append(contentsOf: node.outputs)
        }
        depth += 1
    }
    
    solution.partOne = "\(totalOrbits)"
    
    orbits.resetVisits()
    depth = -1
    toVisit = orbits.nodes["YOU"]!.inputs
    visitor: while !toVisit.isEmpty {
        let thisVisit = toVisit
        toVisit.removeAll()
        for node in thisVisit {
            if node.completed { continue }
            if node.value == "SAN" {
                break visitor
            }
            node.completed = true
            toVisit.append(contentsOf: node.outputs)
            toVisit.append(contentsOf: node.inputs)
        }
        depth += 1
    }
    
    solution.partTwo = "\(depth)"
    return solution
}

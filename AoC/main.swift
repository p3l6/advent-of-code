//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input = puzzleInput
"""
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
"""

class Disk {
    var name = ""
    var weight = 0
    
    var parent :Disk? = nil
    var subDisks : [Disk] = []
    
    lazy var totalWeight: Int  = {
        var childWeight = 0
        for d in subDisks {
            childWeight += d.totalWeight
        }
        return weight + childWeight
    }()
    
    func difference() -> Int {
        guard subDisks.first != nil else { return 0 }
        
        for c in subDisks[1...] {
            if c.totalWeight != subDisks.first!.totalWeight {
                return abs(c.totalWeight - subDisks.first!.totalWeight )
            }
        }
        return 0
    }
}

var diskMap :[String:Disk]  = [:]

for line in input.split(separator: "\n") {
    let elements = line.split(separator: " ")
    
    let n = String(elements[0])
    let disk = diskMap[n] ?? Disk()
    diskMap[n] = disk
    
    disk.name = n
    
    var w = String(elements[1])
    w.removeFirst()
    w.removeLast()
    if let wt = Int(w) {
        disk.weight = wt
    }
    
    //subDisks
    if elements.count > 2 {
        for sd in elements[3...] {
            var name  = String(sd)
            if name.hasSuffix(",") {
                name.removeLast()
            }
            let subDisk = diskMap[name] ?? Disk()
            subDisk.parent = disk
            disk.subDisks.append(subDisk)
            diskMap[name] = subDisk
        }
    }
}

// find root disk

var rootDisk = diskMap[diskMap.keys.first!]!
while rootDisk.parent != nil {
    rootDisk = rootDisk.parent!
}

print("part one: \(rootDisk.name)") // hlhomy

for disk in diskMap.values {
    let diff = disk.difference()
    if diff != 0 {
        print("part two: \(disk.name) is unbalanced") // 1505
        for sd in disk.subDisks {
            print(" sub-disk \(sd.name) weighs \(sd.weight) for a total of \(sd.totalWeight)")
        }
        break
    }
}

execTime.end()

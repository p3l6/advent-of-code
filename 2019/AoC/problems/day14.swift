//
//  day14.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay14 = false

struct Reaction {
    let needs :[String:Int]
    let produced :[String:Int]
    
    var balanced :Bool {
        return missing == nil
    }
    
    func combine(with: Reaction, scale: Int = 1) -> Reaction {
        var needs = self.needs
        var produced = self.produced
        for (need, amt) in with.needs {
            needs[need] = (needs[need] ?? 0) + amt * scale
        }
        for (prod, amt) in with.produced {
            produced[prod] = (produced[prod] ?? 0) +  amt * scale
        }
        return Reaction(needs: needs, produced: produced)
    }
    
    var missing: String? {
        for (chem, amt) in needs {
            if chem == "ORE" { continue }
            if (produced[chem] ?? 0) < amt {
                return chem
            }
        }
        return nil
    }
}

func oreNeeded(forFuel fuelNeeded: Int, basicRxns:[String:Reaction]) -> Int {
    var full = Reaction(needs: ["FUEL":fuelNeeded], produced:[:])
    while !full.balanced {
        let missing = full.missing!
        let reaction = basicRxns[missing]!
        let needed = (full.needs[missing]! - (full.produced[missing] ?? 0))
        let scale =  Double(needed) / Double(reaction.produced[missing]!)
        full = full.combine(with: reaction, scale: Int(ceil(scale)))
    }
    let oreNeeded = full.needs["ORE"]!
    return oreNeeded
}

func day14 (_ input:String) -> Solution {
    var solution = Solution()
    
    var reactions = [String:Reaction]()
        
    for line in input.lines() {
        let inputString = line.substring(before: " => ")
        let outputString = line.substring(after: " => ")
        let inputStrings = inputString.stringArray(",")
        
        var components = outputString.stringArray(" ")
        let output = [components[1]:Int(components[0])!]
        let outputChemical = components[1]
        var input = [String:Int]()
        for str in inputStrings {
            components = str.stringArray(" ")
            input[components[1]] = Int(components[0])!
        }
        reactions[outputChemical] = Reaction(needs: input, produced: output)
    }
    
    let orePerFuel = oreNeeded(forFuel: 1, basicRxns: reactions)
    solution.partOne = "\(orePerFuel)"
    
    let trillion = 1_000_000_000_000
    let estimate = trillion / orePerFuel
    
    // Binary search above this estimate
    var notEnough = estimate
    var tooMuch = estimate * 2
    while tooMuch - notEnough > 1 {
        let middle = (notEnough+tooMuch)/2
        if trillion < oreNeeded(forFuel:middle, basicRxns: reactions) {
            tooMuch = middle
        } else {
            notEnough = middle
        }
    }
    
    solution.partTwo = "\(notEnough)"
    return solution
}

//
//  day1.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay1 = false

func day1 (_ input:String) -> Solution {
    var solution = Solution()
    
    let fuel = input.integerArray("\n").reduce(0) { (sum, mass) -> Int in
        sum + (mass / 3 - 2)
    }
    solution.partOne = "\(fuel)"
    
    let fuelPlus = input.integerArray("\n").reduce(0) { (sum, mass) -> Int in
        let fuel = (mass / 3 - 2)
        
        var lastFuel = fuel
        var extraFuel = 0
        
        while lastFuel != 0 {
            let fuelForLastFuel = max(0, lastFuel / 3 - 2)
            extraFuel += fuelForLastFuel
            lastFuel = fuelForLastFuel
        }
        
        return sum + fuel + extraFuel
    }
    
    solution.partTwo = "\(fuelPlus)"
    return solution
}

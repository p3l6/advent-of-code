//
//  day11.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay11 = true

func day11 (_ input:String) -> Solution {
    var solution = Solution()
    
    let area = Area(at: Point(0,0), w: 300, h: 300)
    let powerLevels = FiniteGrid<Int>(defaultValue: 0, area:area )
    let gridSerial = Int(input)!
    
    for p in area {
        let rackId = p.x + 10
        var power = rackId * p.y
        power += gridSerial
        power *= rackId
        power = (power / 100) % 10
        power -= 5
        powerLevels[p] = power
    }
    
    var maxPower = (0,Point(1,1),3)
    for p in area {
        if !area.contains(point: p+(2,2)) { continue }
        let totalPower = powerLevels[p] + powerLevels[p+(1,0)] + powerLevels[p+(2,0)] +
                         powerLevels[p+(0,1)] + powerLevels[p+(1,1)] + powerLevels[p+(2,1)] +
                         powerLevels[p+(0,2)] + powerLevels[p+(1,2)] + powerLevels[p+(2,2)]
        if totalPower > maxPower.0 {
            maxPower = (totalPower,p,3)
        }
    }
    
    solution.partOne = "\(maxPower.1.x),\(maxPower.1.y)"
    
    maxPower = (0,Point(1,1),3)
    
    
    for p in area {
//        if p.x == 0 { print("\(p.y) out of 300") }
        var totalPower = powerLevels[p]
        for size in 2...300 {
            if !area.contains(point: p+(size-1,size-1)) { break }
            
            for sumPoint in Area(at:Point(p.x+size-1,p.y), w:1, h: size) {
                totalPower += powerLevels[sumPoint]
            }
            for sumPoint in Area(at:Point(p.x,p.y+size-1), w:size-1, h: 1) {
                totalPower += powerLevels[sumPoint]
            }
            
            if totalPower > maxPower.0 {
                maxPower = (totalPower,p,size)
            }
        }
    }
    
    solution.partTwo = "\(maxPower.1.x),\(maxPower.1.y),\(maxPower.2)"
    // 281_874 ms
    // TODO make this much faster somehow
    return solution
}

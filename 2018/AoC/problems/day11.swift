//
//  day11.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay11 = false

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
    
    // https://en.wikipedia.org/wiki/Summed-area_table
    let sumTable = FiniteGrid<Int>(defaultValue: 0, area: area)
    
    for p in area {
        sumTable[p] = powerLevels[p]
        if p.x != 0 && p.y != 0 {
            sumTable[p] += sumTable[p+( 0,-1)]
            sumTable[p] += sumTable[p+(-1, 0)]
            sumTable[p] -= sumTable[p+(-1,-1)] // See refernce link above
        } else if  p.x != 0 {
            sumTable[p] += sumTable[p+(-1,0)]
        } else if p.y != 0 {
            sumTable[p] += sumTable[p+( 0,-1)]
        }
    }
    
    var maxPower = (0,Point(1,1),3)
    var maxPower3 = (0,Point(1,1))
    
    for size in 1...299 {
        for p in Area(at: area.start + (size,size), w: area.width-size, h: area.width-size) {
            
            let  totalPower = sumTable[p] + sumTable[p-(size,size)] - sumTable[p-(size,0)] - sumTable[p-(0,size)]
            
            if totalPower > maxPower.0 {
                maxPower = (totalPower, p - (size-1,size-1), size)
            }
            if size == 3 && totalPower > maxPower3.0 {
                maxPower3 = (totalPower, p - (size-1,size-1))
            }
        }
    }
    
    solution.partOne = "\(maxPower3.1.x),\(maxPower3.1.y)"
    solution.partTwo = "\(maxPower.1.x),\(maxPower.1.y),\(maxPower.2)"
    return solution
}

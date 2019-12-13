//
//  day12.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay12 = true

func day12 (_ input:String) -> Solution {
    var solution = Solution()
    var moons :[SpacePoint] = input.lines().map {
        let ints = $0.extract(format: "<x=%, y=%, z=%>")!
        return SpacePoint(ints[0],ints[1],ints[2])
    }
    
    var velocities = Array(repeating: (x:0,y:0,z:0), count: 4)
    
    for _ in 0..<1000 {
        for i in 0..<3 { // all but last
            for j in i+1..<4 { // after i, including last
                if moons[i].x != moons[j].x {
                    velocities[i].x += moons[i].x < moons[j].x ? 1 : -1
                    velocities[j].x += moons[i].x < moons[j].x ? -1 : 1
                }
                if moons[i].y != moons[j].y {
                    velocities[i].y += moons[i].y < moons[j].y ? 1 : -1
                    velocities[j].y += moons[i].y < moons[j].y ? -1 : 1
                }
                if moons[i].z != moons[j].z {
                    velocities[i].z += moons[i].z < moons[j].z ? 1 : -1
                    velocities[j].z += moons[i].z < moons[j].z ? -1 : 1
                }
            }
        }
        for i in 0..<4 {
            moons[i] = moons[i] + velocities[i]
        }
    }
    
    var energy = 0
    for i in 0..<4 {
        let pot = moons[i].taxi(to: SpacePoint(0,0,0))
        let kin = abs(velocities[i].x) + abs(velocities[i].y) + abs(velocities[i].z)
        energy += kin * pot
    }
    
    solution.partOne = "\(energy)"
//    solution.partTwo = "\()"
    return solution
}

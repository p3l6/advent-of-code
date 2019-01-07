//
//  day25.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay25 = false

func day25 (_ input:String) -> Solution {
    var solution = Solution()
    let distance = 3
    
    let points :[TimeSpacePoint] = input.lines().map { line -> TimeSpacePoint in
        let ex = line.extract(format:"%,%,%,%")!
        return TimeSpacePoint(ex[0],ex[1],ex[2],ex[3])
    }
    
    var constellations = [Set<TimeSpacePoint>]()
    
    toNextPoint: for point in points {
        var newCon = Set<TimeSpacePoint>([point])
        var oldCons = [Int]()
        
        toNextCon: for (i, con) in constellations.enumerated() {
            for star in con {
                if star.taxi(to: point) <= distance {
                    newCon = newCon.union(con)
                    oldCons.append(i)
                    continue toNextCon
                }
            }
        }
        
        oldCons.reversed().forEach {constellations.remove(at: $0)}
        constellations.append(newCon)
    }
    
    solution.partOne = "\(constellations.count)"
//    solution.partTwo = "\()"
    return solution
}

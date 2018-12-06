//
//  problem.swift
//  AoC
//
//  Created by Paul Landers on 11/8/18.
//

import Foundation

let problemDay = 6

let UNOWNED = -1
let TIED = -2

func printGrid(_ grid:[[Int]]) {
    grid.map { (row) -> String in
        row.reduce("", { (s, owner) -> String in
            switch owner {
            case TIED: return s + "."
            case UNOWNED: return s + " "
            default: return s + "\(owner)"
            }
        })
    }.forEach { (s) in print(s) }
}

func problem(_ input:String) -> Solution {
    var solution = Solution()
    
    let ownerLocations = input.lines().map { (str) -> Point in
        let parts = str.extract(format: "%, %")!
        return Point(parts[0],parts[1])
    }
    
    var window = Area(asBoundingBoxOf: ownerLocations)
    window = window.outset(by: 1)

    var grid = [[Int]](repeatElement([Int](repeating: UNOWNED, count: window.width), count: window.height))
    var safeRegionSize = 0
    
// for each in grid, find min distance and sum of distances
    for point in window {
        let distances :[Int] = ownerLocations.map { $0.taxi(to: point) }
        let min = distances.min()!
        let count = distances.reduce(0) { count, dist in dist == min ? count + 1 : count }
        grid[point.y-window.start.y][point.x-window.start.x] = count>1 ? TIED : distances.firstIndex(of: min)!
        
        let sum = distances.reduce(0, +)
        if sum < 10_000 {
            safeRegionSize += 1
        }
    }
    
//    Count owners
    var ownerCounts = [Int](repeating: 0, count: ownerLocations.count)
    for row in grid {
        for owner in row {
            if owner >= 0 {
                ownerCounts[owner] += 1
            }
        }
    }
    
//    Reject window border
    for owner in grid[0] { if owner >= 0 { ownerCounts[owner] = 0 }}
    for owner in grid[grid.count-1] { if owner >= 0 { ownerCounts[owner] = 0 }}
    for row in grid {
        if row[0] >= 0 { ownerCounts[row[0]] = 0}
        if row[row.count-1] >= 0 { ownerCounts[row[row.count-1]] = 0 }
    }

    solution.partOne = "\(ownerCounts.max()!)"
    solution.partTwo = "\(safeRegionSize)"
    
    return solution
}

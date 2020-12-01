//
//  day15.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay15 = false

enum DroneStatus :Int {
    case wall = 0
    case moved = 1
    case oxygen = 2
}

func moveDrone(_ drone: Intcode, to:Direction) -> DroneStatus {
    var inputCode = 1
    switch to {
    case .north: inputCode = 1
    case .south: inputCode = 2
    case .west: inputCode = 3
    case .east: inputCode = 4
    }
    drone.addInput(inputCode)
    
    let _ = drone.run()
    let status = DroneStatus(rawValue:drone.output.last!)!
    return status
}

typealias VisitType = (loc: Point, drone:Intcode)

func day15 (_ input:String) -> Solution {
    var solution = Solution()
    
    // map of distances from origin. -1 for unvisited, -2 for wall
    let drone = Intcode(string: input)
    let map = InfiniteGrid(defaultValue: -1)
    
    var depth = 0
    map[Point(0,0)] = depth
    
    var toVisit = [VisitType(loc: Point(0,0), drone:drone) ]
    var foundAt :Point? = nil
    
    while !toVisit.isEmpty {
        var nextVisit =  [VisitType]()
        
        for (loc, prog) in toVisit {
            for dir in Direction.all() {
                let n = loc.move(dir)
                if map[n] == -1 {
                    let fork = prog.fork()
                    let status = moveDrone(fork, to: dir)
                    switch status {
                    case .wall:
                        map[n] = -2
                    case .moved:
                        map[n] = depth + 1
                        nextVisit.append((n,fork))
                    case .oxygen:
                        map[n] = depth + 1
                        foundAt = n
                    }
                }
            }
        }
        toVisit = nextVisit
        depth += 1
    }
   
    solution.partOne = "\(map[foundAt!])"
    
    // -3 for oxygen spread
    map[foundAt!] = -3
    toVisit = [(foundAt!, drone)]
    var minutes = -1
    while !toVisit.isEmpty {
        var nextVisit =  [VisitType]()
        minutes += 1
        
        for (loc, drone) in toVisit {
            for n in loc.adjacents() {
                if map[n] >= 0 {
                    nextVisit.append((n, drone))
                    map[n] = -3
                }
            }
        }
        toVisit = nextVisit
    }
    
    solution.partTwo = "\(minutes)"
    return solution
}

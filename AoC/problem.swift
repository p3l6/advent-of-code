//
//  problem.swift
//  AoC
//
//  Created by Paul Landers on 11/8/18.
//

import Foundation

let problemDay = 3

struct Claim {
    let id :Int
    let x :Int
    let y: Int
    let width :Int
    let height :Int
    
    init(_ string :String) {
        let components = string.components(separatedBy: " ")
        var id = components[0]
        id.removeFirst()
        self.id = Int(id)!
        var pos = components[2]
        pos.removeLast()
        self.x = Int(pos.components(separatedBy: ",")[0])!
        self.y = Int(pos.components(separatedBy: ",")[1])!
        let size = components[3]
        self.width = Int(size.components(separatedBy: "x")[0])!
        self.height = Int(size.components(separatedBy: "x")[1])!
    }
}

func problem(_ input:String) -> Solution {
    var solution = Solution()
    
    let claims = input.lines().map { (str) -> Claim in return Claim(str) }
    
    var points = [Point:Int]()
    
    
    for c in claims {
        for x in c.x..<c.x+c.width {
            for y in c.y..<c.y+c.height {
                if points[Point(x:x,y:y)] == nil {
                    points[Point(x:x,y:y)] = 0
                }
                points[Point(x:x,y:y)] = points[Point(x:x,y:y)]! + 1
            }
        }
    }
    
    var disputed = 0
    for (_,count) in points {
        if count > 1 {
            disputed += 1
        }
    }
    solution.partOne = "\(disputed)"
    
    for c in claims {
        var disputed = false
        toClaims: for x in c.x..<c.x+c.width {
            for y in c.y..<c.y+c.height {
                if let p = points[Point(x:x,y:y)], p > 1 {
                    disputed = true
                    break toClaims
                }
            }
        }
        if !disputed {
            solution.partTwo = "\(c.id)"
            break
        }
    }
    
    return solution
}

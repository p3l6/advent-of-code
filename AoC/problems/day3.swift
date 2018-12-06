//
//  day3.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay3 = false

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


func day3 (_ input:String) -> Solution {
    var solution = Solution()
    
    let claims = input.lines().map { (str) -> Claim in return Claim(str) }
    
    let points = InfiniteGrid<Int>(defaultValue: 0)
    
    for c in claims {
        for p in Area(at: Point(c.x,c.y), w:c.width, h:c.height) {
            points[p] = points[p] + 1
        }
    }
    
    var disputed = 0
    points.forEach() { (_,count) in
        if count > 1 {
            disputed += 1
        }
    }
    solution.partOne = "\(disputed)"
    
    for c in claims {
        var disputed = false
        for p in Area(at: Point(c.x,c.y), w:c.width, h:c.height) {
            if points[p] > 1 {
                disputed = true
                break
            }
        }
        if !disputed {
            solution.partTwo = "\(c.id)"
            break
        }
    }
    
    return solution
}

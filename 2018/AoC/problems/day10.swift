//
//  day10.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay10 = false

func day10 (_ input:String) -> Solution {
    var solution = Solution()
    
    var points = [(Point,Int,Int)]()
    
    for line in input.lines() {
        let e = line.extract(format: "position=<%, %> velocity=<%,%>")!
        points.append((Point(e[0],e[1]),e[2],e[3]))
    }
    var area = Area(asBoundingBoxOf: points.map{$0.0} )
    
    for step in 0... {
        for i in 0..<points.count {
            let prevPoint = points[i].0
            points[i].0 = prevPoint + (points[i].1,points[i].2)
        }
        
        let prevArea = area
        area = Area(asBoundingBoxOf: points.map{$0.0} )
        if area.area > prevArea.area {
            var chars :[[Character]] = [[Character]](repeating: [Character](repeating: ".", count: prevArea.width), count: prevArea.height)
            for i in 0..<points.count {
                let prevPoint = points[i].0 - (points[i].1,points[i].2)
                chars[prevPoint.y - prevArea.start.y][prevPoint.x - prevArea.start.x] = "#"
            }
            print("--------------\nstep \(step)\n---------------")
            solution.partTwo = "\(step)"
            
            for row in chars {
                print(String(row))
            }
            
            break
        }
    }
    
    // TODO  how to extract the answer?
    
    solution.partOne = "RLEZNRAN"
    return solution
}

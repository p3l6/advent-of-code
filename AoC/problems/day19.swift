//
//  day19.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay19 = false

func day19 (_ input:String) -> Solution {
    var solution = Solution()
    Direction.defaultOrigin = .topLeft
    
    let prog = Intcode(string: input)
    let area = Area(at: Point(0,0), w: 50, h: 50)
    
    var affected = 0
    for p in area {
        prog.reset()
        prog.addInput(p.x)
        prog.addInput(p.y)
        let _ = prog.run()
        let status = prog.output.last!
        if status == 1 {
            affected += 1
        }
    }
    
    solution.partOne = "\(affected)"
    
//    let yBottom =
//    
//    for x in 0... {
//        let ybottom = x * slopeBottom
//        let yTop = (x+100) * slopeTop
//        let diff = yTop - ybottom
//        if diff == 100 {
//            solution.partTwo = "\(x * 10_000 + x + 100)"
//            break
//        }
//    }
//    
    return solution
}

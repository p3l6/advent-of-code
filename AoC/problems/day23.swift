//
//  day23.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay23 = false

struct Nanobot {
    let pos: SpacePoint
    let radius :Int
    func inRange(_ loc:SpacePoint) -> Bool {
        return pos.taxi(to: loc) <= radius
    }
}

func day23 (_ input:String) -> Solution {
    var solution = Solution()
    
    let bots : [Nanobot] = input.lines().map {
        let x = $0.extract(format: "pos=<%,%,%>, r=%")!
        return Nanobot(pos:SpacePoint(x[0],x[1],x[2]), radius:x[3])
    }
    
    let maxBot :Nanobot = bots.reduce(bots.first!, {$0.radius < $1.radius ? $1 : $0} )
    let count = bots.reduce(0) { maxBot.inRange($1.pos) ? $0 + 1 : $0 }
    
    solution.partOne = "\(count)"
    return solution

    var counts = [SpacePoint:Int]()
    
    // make groups of any bots that share points whith each other
    // take the largest group
    // start a group with each bot
//      for each bot, if a.taxi(b) < a.r + b.r ==> then they share points
    /// hmmm
   
    for bot in bots {
//    
//        let range = (min:SpacePoint(bot.pos.x - bot.radius, bot.pos.y - bot.radius, bot.pos.z - bot.radius),
//                     max:SpacePoint(bot.pos.x + bot.radius, bot.pos.y + bot.radius, bot.pos.z + bot.radius))
    
        //var max = (count:0, at:SpacePoint(0,0,0))
        for ring in -bot.radius ..< bot.radius {
            let x = bot.pos.x + ring
            let ringWidth = 2*bot.radius - ring
            for y in (bot.pos.y - ringWidth)...(bot.pos.y + ringWidth) {
                for z in (bot.pos.z - ringWidth)...(bot.pos.z + ringWidth) {
                    let p = SpacePoint(x,y,z)
                    
                    counts[p] = (counts[p] ?? 0) + 1
//                    let count = bots.reduce(0) { $1.inRange(p) ? $0 + 1 : $0 }
//                    if count > max.count {
//                        max = (count, p)
//                    }
                }
            }
        }
    }
    
    var max = counts.first!
    for (point, count) in counts {
        if count > max.value {
            max = (point,count)
        }
    }
    
    solution.partTwo = "\(max.key.taxi(to: SpacePoint(0,0,0)))"
//    solution.partTwo = "\(max.at.taxi(to: SpacePoint(0,0,0)))"
    return solution
}

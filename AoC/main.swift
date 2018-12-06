//
//  main.swift
//  AoC
//
//  Created by Paul Landers on 11/8/18.
//

import Foundation

func runay(_ problemDay:Int, _ problem:Problem, check:Bool = true) {

    print("day: \(problemDay)")

    let auth = Auth()

    var input = auth.input(day: problemDay) // day is configured in problem.swift
    if input.hasSuffix("\n") {
        input.removeLast()
        print("stripped trailing newline from input")
    }
    let numLines = input.split(separator: "\n").count
    let numChars = input.count
    switch numLines {
    case 0:
        print("no input for today's problem")
    case 1 where input.count < 80:
        print("input: \(input)")
    case 2...4 where numChars < 80*numLines:
        print("input:\n------\n\(input)\n------")
    default:
        print("input omitted: \(numLines) lines and \(numChars) characters long")
    }
    
    let execTime = TicToc(named:"today's problems")
    
    let sol = problem(input)
    
    execTime.end()
    
    print("part one: \(sol.partOne)")
    print("part two: \(sol.partTwo)")
    
    if check {
        let (a,b) = auth.check(day: problemDay, sol: sol)
        
        if a && b {
            print("both parts correct!")
        }
    }
}

let days :[(Int, Bool,Problem)] = [(1,runDay1,day1), (2,runDay2,day2),(3,runDay3,day3),(4,runDay4,day4),(5,runDay5,day5),
                                   (6,runDay6,day6),(7,runDay7,day7),(8,runDay8,day8),(9,runDay9,day9),(10,runDay10,day10),
                                   (11,runDay11,day11),(12,runDay12,day12),(13,runDay13,day13),(14,runDay14,day14),(15,runDay15,day15),
                                   (16,runDay16,day16),(17,runDay17,day17),(18,runDay18,day18),(19,runDay19,day19),(20,runDay20,day20),
                                   (21,runDay21,day21),(22,runDay22,day22),(23,runDay23,day23),(24,runDay24,day24),(25,runDay25,day25),]
for (day, shouldRun, function) in days {
    if (overrideRange == nil && shouldRun) ||
        (overrideRange != nil && overrideRange!.contains(day)) {
        runay(day, function, check: false)
    }
}

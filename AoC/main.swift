//
//  main.swift
//  AoC
//
//  Created by Paul Landers on 11/8/18.
//

import Foundation

print("day: \(problemDay)")

let auth = Auth()

let input = auth.input(day: problemDay) // day is configured in problem.swift
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

let (a,b) = auth.check(day: problemDay, sol: sol)

if a && b {
    print("both parts correct!")
}

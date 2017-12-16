//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input =  puzzleInput

var initial :[Character] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p"]
var progs = initial

func danceOnce(from:[Character]) -> [Character] {
    var progs = from
    for move in input.split(separator: ",") {
        let moveDirections = move.dropFirst()
        switch move.first! {
        case "s":
            let count = Int(moveDirections)!
            let lastItems = progs[(progs.count-count)...]
            progs.removeLast(count)
            progs.insert(contentsOf: lastItems, at: 0)
        case "x":
            let a = Int( moveDirections.split(separator: "/")[0] )!
            let b = Int( moveDirections.split(separator: "/")[1] )!
            let t = progs[a]
            progs[a] = progs[b]
            progs[b] = t
        case "p":
            let a = progs.index(of:moveDirections.first!)!
            let b = progs.index(of:moveDirections.last!)!
            let t = progs[a]
            progs[a] = progs[b]
            progs[b] = t
        default:
            break
        }
    }
    return progs
}

print("part one: \(String(danceOnce(from:progs)))") // ionlbkfeajgdmphc

// The thing I tried to do first, and had to look up a hint why it wasnt working; was a one-dance transformation mapping. then applied repeatedly
// turns out this won't work because of the partner switch move, of course!

progs = initial
var cycleCount = 0
repeat {
    progs = danceOnce(from: progs)
    cycleCount+=1
} while progs != initial

progs = initial
for _ in 0..<(1_000_000_000%cycleCount) {
    progs = danceOnce(from: progs)
}

print("part two: \(String(progs))") // fdnphiegakolcmjb

execTime.end()

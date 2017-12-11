//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input =  puzzleInput
"se,sw,se,sw,sw"

struct Place {
    var n = 0
    var ne = 0
    var nw = 0
    var s = 0
    var se = 0
    var sw = 0
    
    func distance () -> Int { // must be simplified
        return ne + nw + n + s + se + sw
    }
}

var location = Place()
var maxDistance = 0

func simplify(location :Place) -> Place {
    var loc = location
    while true {
        if      (loc.n  > 0 && loc.s  > 0) { let x = min(loc.n ,loc.s ); loc.n  -= x; loc.s  -= x }
        else if (loc.ne > 0 && loc.sw > 0) { let x = min(loc.ne,loc.sw); loc.ne -= x; loc.sw -= x }
        else if (loc.nw > 0 && loc.se > 0) { let x = min(loc.nw,loc.se); loc.nw -= x; loc.se -= x }
        
        else if (loc.n  > 0 && loc.se > 0) { let x = min(loc.n ,loc.se); loc.n  -= x; loc.se -= x; loc.ne += x }
        else if (loc.n  > 0 && loc.sw > 0) { let x = min(loc.n ,loc.sw); loc.n  -= x; loc.sw -= x; loc.nw += x }
        else if (loc.sw > 0 && loc.se > 0) { let x = min(loc.sw,loc.se); loc.sw -= x; loc.se -= x; loc.s  += x }
            
        else if (loc.s  > 0 && loc.nw > 0) { let x = min(loc.s ,loc.nw); loc.s  -= x; loc.nw -= x; loc.sw += x }
        else if (loc.s  > 0 && loc.ne > 0) { let x = min(loc.s ,loc.ne); loc.s  -= x; loc.ne -= x; loc.se += x }
        else if (loc.nw > 0 && loc.ne > 0) { let x = min(loc.nw,loc.ne); loc.nw -= x; loc.ne -= x; loc.n  += x }
            
        else { break }
    }
    return loc
}

for dir in input.split(separator: ",") {
    switch dir {
    case "n": location.n += 1
    case "ne": location.ne += 1
    case "nw": location.nw += 1
    case "s": location.s += 1
    case "se": location.se += 1
    case "sw": location.sw += 1
    default:
        break
    }
    
    let d = simplify(location: location).distance()
    if d > maxDistance {
        maxDistance = d
    }
}

location = simplify(location: location)

print("part one: \(location.distance())") // 707
print("part two: \(maxDistance)") // 1490

execTime.end()

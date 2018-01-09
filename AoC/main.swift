//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input = puzzleInput
"""
0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10
"""

struct Component {
    let a : Int
    let b : Int
    var strength : Int { return a + b }
    func reversed() -> Component { return Component(a:b, b:a) }
}

struct Bridge : CustomStringConvertible {
    let used : [Component]
    let unused : [Component]
    
    var strength : Int { var s = 0; used.forEach({s+=$0.strength}); return s }
    var length : Int { return used.count }
    
    func extensions() -> [Bridge]{
        var ret = [Bridge]()
        let next = used.isEmpty ? 0 : used.last!.b
        for (i,com) in unused.enumerated()  {
            if com.a == next {
                var remaining = unused
                remaining.remove(at: i)
                ret.append(Bridge(used: used+[com],
                                  unused: remaining))
            } else if com.b == next {
                var remaining = unused
                remaining.remove(at: i)
                ret.append(Bridge(used: used+[com.reversed()],
                                  unused: remaining))
            }
        }
        return ret
    }
    
    var description: String {
        var s = ""; used.forEach({s+="\($0.a)/\($0.b)--"}); return s
    }
}

let emptyBridge = Bridge(used:[],
                         unused:input.split(separator: "\n").map({
                            let s = String($0).integerArray("/");
                            return Component(a:s[0], b:s[1])
                         }))

var eval = Stack<Bridge>()
eval.push(emptyBridge)
var strongest = emptyBridge
var longest = emptyBridge

while !eval.isEmpty {
    let bridge = eval.pop()
   
   // print (bridge)
    let ext = bridge.extensions()
    if ext.isEmpty {
        if bridge.strength > strongest.strength {
            strongest = bridge
        }
        if bridge.length > longest.length || bridge.length == longest.length && bridge.strength > longest.strength {
            longest = bridge
        }
    } else {
        ext.forEach { eval.push($0) }
    }
}

print("part one: \(strongest.strength)") // 2006

print("part two: \(longest.strength)")  // 1994 

execTime.end()

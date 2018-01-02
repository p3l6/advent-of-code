//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input = puzzleInput

var pc = 0
var registers :[String:Int] = ["a":0, "b":0,"c":0,"d":0,"e":0,"f":0,"g":0,"h":0]

let prog :[(inst:String, reg:String, val:String)] = input.split(separator: "\n").map { line in
    let p = line.split(separator: " ")
    return (inst:String(p[0]), reg:String(p[1]), val:String(p[2]) )
}

func value(_ xIn:String?) -> Int {
    guard let x = xIn else {
        return 0
    }
    return Int(x) ?? registers[x] ?? 0
}

var multCount = 0

while pc < prog.count {
    let line = prog[pc]
    switch line.inst {
    case "set":
        registers[line.reg] = value(line.val)
    case "sub":
        registers[line.reg] = value(line.reg) - value(line.val)
    case "mul":
        registers[line.reg] = value(line.reg) * value(line.val)
        multCount += 1
    case "jnz":
        if value(line.reg) != 0 {
            pc += value(line.val)
            pc -= 1 // don't increase pc later
        }
    default:
        break
    }
    pc += 1
}


print("part one: \(multCount)") // 9409

var a = 1, b = 0, c = 0, d = 0 , e = 0, f = 0, g = 0, h = 0
pc = 0
multCount += 1


b = 99 * 100 + 100000
c = b + 17000

// this just counts the non-prime numbers between b and c, skipping by 17

forloop: for n in stride(from: b, through: c, by: 17) {
    var i = 2
    while i*i <= n {
        if n % i == 0 {
            h += 1
            continue forloop
        }
        i = i + 1
    }
}

/*
repeat {
    print(a,b,c,d,e,f,g,h)
    f = 1;
    d = 2;
    repeat {
        e = 2;
        repeat {
            if e*d == b {
                f = 0
            }
            e += 1
        } while e != b
        d += 1
    } while d != b
    
    if f == 0 {
        h += 1
    }
    if b == c {
        break
    }
    b += 17
} while true
*/
print("part two: \(h)")  // 913

execTime.end()

//
//  day25.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay25 = false

func day25 (_ input:String) -> Solution {
    var solution = Solution()
    let droid = Intcode(string: input)
    
    let instructions = """
east
north
west
north
west
take astrolabe
east
south
south
take antenna
north
east
take coin
south
take whirled peas
east
north
take prime number
south
east
east
east
take dark matter
west
west
west
west
west
north
take fixed point
north
take weather machine
east
drop astrolabe
drop dark matter
drop fixed point
drop whirled peas
drop coin
drop antenna
drop prime number
drop weather machine
"""
    
    let _ = droid.run()
    print(droid.asciiOutput(clear:true))
    for instruction in instructions.lines() {
        droid.addAsciiInput(instruction)
        droid.addInput(10)
        let _ = droid.run()
        print(droid.asciiOutput(clear:true))
    }
    
    droid.addAsciiInput("south\n")
    let _ = droid.run()
    var response = droid.asciiOutput(clear:true)
    let items = ["fixed point","whirled peas","coin","antenna","prime number","weather machine"]
    var thing = 1
    
    while response.contains("== Security Checkpoint ==")  && thing < 1<<6{
        let subitems = items.enumerated().filter({ (index,string) in
            return (1 << index) & thing != 0
        }).map({ $0.1})
        
        for take in subitems {
            droid.addAsciiInput("take \(take)")
            droid.addInput(10)
            let _ = droid.run()
        }
//        droid.clearOutput()
//        droid.addAsciiInput("inv\n")
//        let _ = droid.run()
//        print(droid.asciiOutput(clear:true))
        
        droid.clearOutput()
        droid.addAsciiInput("south\n")
        let _ = droid.run()
        response = droid.asciiOutput(clear:true)
        
        for take in subitems {
            droid.addAsciiInput("drop \(take)")
            droid.addInput(10)
            let _ = droid.run()
        }
        
        thing += 1
    }
    
//    Items in your inventory:
//    - whirled peas
//    - fixed point
//    - prime number
//    - antenna

    print(response)
    
    solution.partOne = "2622472"
//    solution.partTwo = "\()"
    return solution
}

//
//  day12.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay12 = true

func intize(_ arr: ArraySlice<Bool>) -> Int {
    let start = arr.startIndex
    return
        (arr[start+0] ? 1<<4 : 0) |
        (arr[start+1] ? 1<<3 : 0) |
        (arr[start+2] ? 1<<2 : 0) |
        (arr[start+3] ? 1<<1 : 0) |
        (arr[start+4] ? 1 : 0)
}

func grow(gens:Int, map:[Bool], initial:[Bool]) -> ([Bool],Int) {
    var plants = [false,false,false,false] + initial + [false,false,false,false]
    
    var offset = -4
    for g in 0 ..< gens {
        var nextGen = [false,false]
        var offsetDelta = 0
        for i in 2 ..< plants.count-2 {
            nextGen.append(map[intize(plants[i-2..<i+3])])
        }
        
        let first = nextGen.firstIndex(of: true)!
        if first <= 3 {
            nextGen = [false,false,false,false] + nextGen
            offsetDelta -= 4
        } else if first > 10 {
            nextGen.removeFirst(5)
            offsetDelta += 5
        }
        
        if nextGen.lastIndex(of: true)! > nextGen.count - 4 {
            nextGen.append(contentsOf: [false,false,false,false])
        }
      
        if  nextGen[nextGen.firstIndex(of: true)!...nextGen.lastIndex(of: true)!] ==
            plants[plants.firstIndex(of: true)!...plants.lastIndex(of: true)!] {
            // Stable!
            offsetDelta += nextGen.firstIndex(of: true)! - plants.firstIndex(of: true)! // the one-generation shift
            return (nextGen, offset + offsetDelta * (gens-g-1))
        }
        
        offset += offsetDelta
        plants = nextGen
    }
    return (plants, offset)
}

func day12 (_ input:String) -> Solution {
    var solution = Solution()
    
    let initialPlants :[Bool] = input.lines()[0].substring(fromIndex: 15).map {$0=="#"}
    var mapping = [Bool](repeating: false, count: 32)
    for line in input.lines()[1...] {
        let str = line[0..<5]
        let bool = line[9] == "#"
        var index = 0
        for (i,c) in str.enumerated() { if c=="#" {index |= 1<<(4-i)}}
        mapping[index] = bool
    }
    
    assert(mapping.count == 32)
    
    let (gen20, offset) = grow(gens: 20, map: mapping, initial: initialPlants)
    var sum = gen20.enumerated().reduce(0) { (sum, arg1) in let (i, bool) = arg1; return bool ? sum + i + offset : sum }
    solution.partOne = "\(sum)"
    
    let (gen50, offset50) = grow(gens: 50_000_000_000, map: mapping, initial: initialPlants)
    sum = gen50.enumerated().reduce(0) { (sum, arg1) in let (i, bool) = arg1; return bool ? sum + i + offset50 : sum }
    solution.partTwo = "\(sum)"
    
    return solution
}

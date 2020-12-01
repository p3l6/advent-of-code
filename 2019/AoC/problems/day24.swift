//
//  day24.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay24 = false

struct Eris :Hashable {
    var bugs = [Bool]()
    
    static func lives(_ already: Bool, l:Bool, r: Bool, u: Bool, d: Bool) -> Bool {
        let count = (l ? 1:0) + (r ? 1:0) + (u ? 1:0) + (d ? 1:0)
        return already ? count == 1 :  (count == 1 || count == 2)
    }
    
    func process() -> Eris {
        var next = [Bool](repeating: false, count: 25)
        /* grid indexes
         0  1  2  3  4
         5  6  7  8  9
         10 11 12 13 14
         15 16 17 18 19
         20 21 22 23 24
         */
        next[0] =  Eris.lives(bugs[0],  l:false,    r:bugs[1],  u:false,    d:bugs[5])
        next[1] =  Eris.lives(bugs[1],  l:bugs[0],  r:bugs[2],  u:false,    d:bugs[6])
        next[2] =  Eris.lives(bugs[2],  l:bugs[1],  r:bugs[3],  u:false,    d:bugs[7])
        next[3] =  Eris.lives(bugs[3],  l:bugs[2],  r:bugs[4],  u:false,    d:bugs[8])
        next[4] =  Eris.lives(bugs[4],  l:bugs[3],  r:false,    u:false,    d:bugs[9])
        next[5] =  Eris.lives(bugs[5],  l:false,    r:bugs[6],  u:bugs[0],  d:bugs[10])
        next[6] =  Eris.lives(bugs[6],  l:bugs[5],  r:bugs[7],  u:bugs[1],  d:bugs[11])
        next[7] =  Eris.lives(bugs[7],  l:bugs[6],  r:bugs[8],  u:bugs[2],  d:bugs[12])
        next[8] =  Eris.lives(bugs[8],  l:bugs[7],  r:bugs[9],  u:bugs[3],  d:bugs[13])
        next[9] =  Eris.lives(bugs[9],  l:bugs[8],  r:false,    u:bugs[4],  d:bugs[14])
        next[10] = Eris.lives(bugs[10], l:false,    r:bugs[11], u:bugs[5],  d:bugs[15])
        next[11] = Eris.lives(bugs[11], l:bugs[10], r:bugs[12], u:bugs[6],  d:bugs[16])
        next[12] = Eris.lives(bugs[12], l:bugs[11], r:bugs[13], u:bugs[7],  d:bugs[17])
        next[13] = Eris.lives(bugs[13], l:bugs[12], r:bugs[14], u:bugs[8],  d:bugs[18])
        next[14] = Eris.lives(bugs[14], l:bugs[13], r:false,    u:bugs[9],  d:bugs[19])
        next[15] = Eris.lives(bugs[15], l:false,    r:bugs[16], u:bugs[10], d:bugs[20])
        next[16] = Eris.lives(bugs[16], l:bugs[15], r:bugs[17], u:bugs[11], d:bugs[21])
        next[17] = Eris.lives(bugs[17], l:bugs[16], r:bugs[18], u:bugs[12], d:bugs[22])
        next[18] = Eris.lives(bugs[18], l:bugs[17], r:bugs[19], u:bugs[13], d:bugs[23])
        next[19] = Eris.lives(bugs[19], l:bugs[18], r:false,    u:bugs[14], d:bugs[24])
        next[20] = Eris.lives(bugs[20], l:false,    r:bugs[21], u:bugs[15], d:false)
        next[21] = Eris.lives(bugs[21], l:bugs[20], r:bugs[22], u:bugs[16], d:false)
        next[22] = Eris.lives(bugs[22], l:bugs[21], r:bugs[23], u:bugs[17], d:false)
        next[23] = Eris.lives(bugs[23], l:bugs[22], r:bugs[24], u:bugs[18], d:false)
        next[24] = Eris.lives(bugs[24], l:bugs[23], r:false,    u:bugs[19], d:false)
        return Eris(bugs:next)
    }
    
    init(bugs: [Bool]) {
        assert(bugs.count == 25, "Incorrect number of bugs supplied")
        self.bugs = bugs
    }
    
    var bioDiversityRating :Int {
        var bio = 0
        for (i,bug) in bugs.enumerated() {
            if bug {
                bio += (1 << i)
            }
        }
        return bio
    }
    
    func printOut() {
        for y in 0..<5 {
            for x in 0..<5 {
                print(self.bugs[y*5+x] ? "#" : ".", terminator: "")
            }
            print("")
        }
        print("------")
    }
}

func day24 (_ input:String) -> Solution {
    var solution = Solution()
    
    var eris = Eris(bugs:input.filter({$0 != "\n"}).map({$0 == "#"}))
//    eris.printOut()
    
    var layouts = Set<Eris>()
    
    while !layouts.contains(eris) {
        layouts.insert(eris)
        eris = eris.process()
//        eris.printOut()
    }
    
    solution.partOne = "\(eris.bioDiversityRating)"
//    solution.partTwo = "\()"
    return solution
}

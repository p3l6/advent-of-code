
import Foundation

let runDay15 = false

func day15 (_ input:String) -> Solution {
    var solution = Solution()
    let initialSequence = input.integerArray(",")
    
    var mem: [Int: (recent: Int, previous:Int?)] = [:]
    var last = 0
    var time = 0
    for x in initialSequence {
        mem[x] = (time, nil)
        time += 1
        last = x
    }
    
    while time < 30_000_000 {
        guard let (recent, previous) = mem[last] else { print("[ERROR] Last number is not in mem"); break }
        
        let next = previous == nil ? 0 : recent - previous!
        
        mem[next] = (time, mem[next]?.recent)
        time += 1
        last = next
        
        if time == 2020 { solution.partOne = "\(last)" }
    }
    
    solution.partTwo = "\(last)"
    return solution
}


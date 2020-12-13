
import Foundation

let runDay13 = false

func day13 (_ input:String) -> Solution {
    var solution = Solution()
    let lines = input.lines()
    let after = Int(lines[0])!
    let ids = lines[1].stringArray(",")
        .filter { Int($0) != nil }
        .map { Int($0)! }
    
    let waits: [(id:Int, wait:Int)] = ids.map { id in
        let wait = (id*(after/id + 1)) - after
        return (id:id, wait:wait)
    }
    
    let min = waits.min { $0.wait < $1.wait }!
    solution.partOne = "\(min.id * min.wait)"
//    solution.partTwo = "\()"
    return solution
}


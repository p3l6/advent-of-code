
import Foundation

let runDay13 = false

func day13 (_ input:String) -> Solution {
    var solution = Solution()
    let lines = input.lines()
    let after = Int(lines[0])!
    let elements = lines[1].stringArray(",")
    let ids = elements
        .filter { Int($0) != nil }
        .map { Int($0)! }
    
    let waits: [(id:Int, wait:Int)] = ids.map { id in
        let wait = (id*(after/id + 1)) - after
        return (id:id, wait:wait)
    }
    
    let min = waits.min { $0.wait < $1.wait }!
    solution.partOne = "\(min.id * min.wait)"
    
    // This works for the examples, but it is too slow for a real solution
    // I also don't understand why the answer ends up being "stride - t" and not just "t"
    // Sorta derived some of this from wolfram alpha
    
    let offsets: [(id:Int, offset:Int)] = ids.map { id in
        let offset = elements.firstIndex(of: String(id))!
        return (id:id, offset: offset)
    }
    
    var stride = 1
    var t = 0
    for (id, offset) in offsets {
        while t % id != offset {
            t += stride
        }
        stride = stride * id
        print("x = \(stride) n + \(t)")
    }
    
    solution.partTwo = "\(stride - t)"
    return solution
}


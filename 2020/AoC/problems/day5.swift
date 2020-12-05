
import Foundation

let runDay5 = false

struct Seat {
    var row: Int
    var col: Int
    
    init(_ partition: String) {
        var rBound = (min:0, max:127)
        var cBound = (min:0, max:7)
        
        for char in partition {
            switch char {
            case "F": rBound.max = Int(floor(Double(rBound.min + rBound.max)/2.0))
            case "B": rBound.min = Int( ceil(Double(rBound.min + rBound.max)/2.0))
            case "R": cBound.min = Int( ceil(Double(cBound.min + cBound.max)/2.0))
            case "L": cBound.max = Int(floor(Double(cBound.min + cBound.max)/2.0))
            default: print("[Error] Unexpected partition indicator!")
            }
        }
        
        row = rBound.min
        col = cBound.max
    }
    
    var id: Int { row * 8 + col }
}

func day5 (_ input:String) -> Solution {
    var solution = Solution()
    let seats = input.lines().map { Seat($0) }
    let seatIds = seats.map(\.id).sorted()
    solution.partOne = "\(seatIds.max()!)"
    
    for i in 0..<seatIds.count-1 {
        if seatIds[i+1] - seatIds[i] == 2 {
            solution.partTwo = "\(seatIds[i]+1)"
            break
        }
    }
    
    return solution
}


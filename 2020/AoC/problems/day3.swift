
import Foundation

let runDay3 = false

func treeSled(field: [[Bool]], slopeRight: Int, slopeDown: Int) -> Int {
    var col = 0
    var row = 0 // origin-top
    var trees = 0
    let width = field.first!.count
    
    while row < field.count {
        if field[row][col] {
            trees += 1
        }
        
        row += slopeDown
        col = (col + slopeRight) % width
    }
    
    return trees
}

func day3 (_ input:String) -> Solution {
    var solution = Solution()
    let lines = input.lines()
    let trees = lines.map { line in
        line.map { char in
            char == "#"
        }
    }
    
    solution.partOne = "\(treeSled(field: trees, slopeRight: 3, slopeDown: 1))"
    
    let product = [ (1,1), (3,1), (5,1), (7,1), (1,2) ]
        .map { treeSled(field: trees, slopeRight: $0, slopeDown: $1) }
        .reduce(1) { $0 * $1 }
    solution.partTwo = "\(product)"
    return solution
}



import Foundation

let runDay6 = false

func day6 (_ input:String) -> Solution {
    var solution = Solution()
    let lineGroups = input.lineGroups()
    
    let unions = lineGroups.map { Set($0.joined()) }
    
    solution.partOne = "\(unions.map(\.count).sum())"
    
    let intersections = lineGroups.map { group in
        group
            .map { line in Set(line) }
            .reduce(Set("abcdefghijklmnopqrstuvwxyz")) { $0.intersection($1) }
    }

    solution.partTwo = "\(intersections.map(\.count).sum())"
    return solution
}


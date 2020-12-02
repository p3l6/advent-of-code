
import Foundation

let runDay2 = false

struct TobogganPassword {
    let min: Int
    let max: Int
    let req: Character
    let pass: String
    
    func check1() -> Bool {
        let count = pass.filter { $0 == req }.count
        return min <= count && count <= max
    }
    
    func check2() -> Bool {
        let first = Character(pass[min-1]) == req
        let other = Character(pass[max-1]) == req
        return first != other
    }
}

func day2 (_ input:String) -> Solution {
    var solution = Solution()
    let lines = input.lines()
        
    let passwords: [TobogganPassword] = lines.map { line in
        let parts = line.stringArray(" ")
        let limits = String(parts[0]).integerArray("-")
        return TobogganPassword(
            min: limits[0],
            max: limits[1],
            req: parts[1].first!,
            pass: parts[2])
    }
    
    solution.partOne = "\(passwords.count(where: {$0.check1()}))"
    solution.partTwo = "\(passwords.count(where: {$0.check2()}))"
    return solution
}


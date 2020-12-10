
import Foundation

let runDay10 = false

func day10 (_ input:String) -> Solution {
    var solution = Solution()
    let adapters = input.integerArray("\n").sorted()
    
    let differences: [Int] = adapters
        .enumerated()
        .map { (idx, adapter) in
        if idx == 0 { return adapter }
        return adapter - adapters[idx-1]
    }
    
    let product = differences.count(where: {$0 == 1}) * (differences.count(where: { $0 == 3 }) + 1)
    solution.partOne = "\(product)"
    
    var cache = [ArraySlice<Int>:Int]()
    func countSubLists(of list: ArraySlice<Int>) -> Int {
        if list.count == 1 {
            return 1
        } else if let count = cache[list] {
            return count
        }
        
        var count = 0
        let offset = list.startIndex
        for i in offset+1 ..< min(offset+4, list.endIndex) {
            if list[i] - list[offset] <= 3 {
                count += countSubLists(of: list[i...])
            }
        }
        cache[list] = count
        return count
    }
    
    var valids = countSubLists(of: adapters[0...])
    if adapters[1] <= 3 { valids += countSubLists(of: adapters[1...]) }
    if adapters[2] <= 3 { valids += countSubLists(of: adapters[2...]) }
    
    solution.partTwo = "\(valids)"
    
    return solution
}


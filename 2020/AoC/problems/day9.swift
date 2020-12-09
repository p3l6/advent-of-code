
import Foundation

let runDay9 = false

func findPair(of: [Int], withSum: Int) -> Bool {
    for x in of {
        for y in of {
            if x != y && x + y == withSum {
                return true
            }
        }
    }
    return false
}

func day9 (_ input:String) -> Solution {
    var solution = Solution()
    let nums = input.integerArray("\n")
    
    var firstInvalid = 0
    for i in 25..<nums.count {
        let valid = findPair(of: Array(nums[i-25..<i]), withSum: nums[i])
        if !valid {
            firstInvalid = nums[i]
            break
        }
    }
    
    var range = (min: 0, max: 1)
    
    while range.max < nums.count {
        let sumInRange = nums[range.min...range.max].sum()
        if sumInRange == firstInvalid { break }
        else if sumInRange < firstInvalid { range.max += 1 }
        else { range.min += 1 }
    }
    
    solution.partOne = "\(firstInvalid)"
    solution.partTwo = "\(nums[range.min...range.max].min()! + nums[range.min...range.max].max()!)"
    return solution
}


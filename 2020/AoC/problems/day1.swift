
import Foundation

let runDay1 = false

func day1 (_ input:String) -> Solution {
    var solution = Solution()
    
    let nums = input.integerArray("\n")
    
    both: for x in nums {
        for y in nums {
            if x + y == 2020 {
                solution.partOne = "\(x*y)"
                break both
            }
        }
    }
    
    both: for x in nums {
        for y in nums {
            for z in nums {
                if x + y + z == 2020 {
                    solution.partTwo = "\(x*y*z)"
                    break both
                }
            }
        }
    }
    return solution
}


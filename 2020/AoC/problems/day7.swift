
import Foundation

let runDay7 = false

class BagType {
    let color: String
    let contains: [(String, Int)]
    let containedCount: Int
    var hasShinyGold: Bool?
    
    init(data: String) {
        let words = data.stringArray(" ")
        color = words[0...1].joined(separator: " ")
        
        var contains = [(String,Int)]()
        if words[4] != "no" {
            var i = 0
            repeat {
                i += 4
                contains.append((words[i+1...i+2].joined(separator: " "), Int(words[i])!))
            } while words[i+3].last! != "."
        }
        
        self.contains = contains
        self.containedCount = contains.map { $0.1 }.sum()
    }
}

func day7 (_ input:String) -> Solution {
    var solution = Solution()
    let lines = input.lines()
    
    let bagMap: [String: BagType] = lines.map { BagType(data: $0) }.reduce(into: Dictionary()) { $0[$1.color] = $1 }
    
    func findShinyGold(inside bag: BagType) -> Bool {
        for (contained, _) in bag.contains {
            let cBag = bagMap[contained]!
            if  contained == "shiny gold" ||
                (cBag.hasShinyGold != nil && cBag.hasShinyGold!) ||
                (cBag.hasShinyGold == nil && findShinyGold(inside: cBag)) {
                bag.hasShinyGold = true
                return true
            }
        }
        bag.hasShinyGold = false
        return false
    }
    
    for (_, bag) in bagMap {
        if bag.hasShinyGold == nil {
            let _ = findShinyGold(inside: bag)
        }
    }
    
    solution.partOne = "\(bagMap.map{$0.value.hasShinyGold!}.count(where:{$0}))"
    
    
    var bagsToCheck = [(color: "shiny gold", multiplier:1)]
    var totalBags = 0

    while !bagsToCheck.isEmpty {
        let (color, mult) = bagsToCheck.popLast()!
        let bag = bagMap[color]!
        
        totalBags += bag.containedCount * mult
        
        for (color, amount) in bag.contains {
            bagsToCheck.append((color: color, multiplier: amount * mult))
        }
    }
    
    
    solution.partTwo = "\(totalBags)"
    return solution
}


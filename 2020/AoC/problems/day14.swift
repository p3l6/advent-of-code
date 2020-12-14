
import Foundation

let runDay14 = false

struct Mask {
    let ones: Int
    let zeros: Int
    let floats: [Int]

    init(_ data: String) {
        var ones = 0
        var zeros = 0
        var floats = [Int]()
        for (index, char) in data.reversed().enumerated() {
            if char == "1" { ones |= (1 << index) }
            if char == "0" { zeros |= (1 << index) }
            if char == "X" { floats.append(index) }
        }
        self.ones = ones
        self.zeros = ~zeros
        
        if floats.count > 12 {
            // This just guards against long runtimes for part 1 examples in unit tests.
            print("[WARN] More floats than allowed, ignoring")
            floats = []
        }
        
        self.floats = floats
    }
    
    func apply(to: Int) -> Int {
        return (to | ones) & zeros
    }
    
    func decode(address: Int) -> [Int] {
        let base = (address | ones)
        var possibilites = [base]
        for float in floats {
            var expanded = [Int]()
            for poss in possibilites {
                expanded.append(poss | (1 << float))
                expanded.append(poss & ~(1 << float))
            }
            possibilites = expanded
        }
        return possibilites
    }
}

func day14 (_ input:String) -> Solution {
    var solution = Solution()
    let program = input.lines()
    
    var mask = Mask(program[0].substring(after: "mask = "))
    var mem1 = [Int: Int]()
    var mem2 = [Int: Int]()
    for line in program {
        if line.hasPrefix("mask") {
            mask = Mask(line.substring(after: "mask = "))
        } else {
            let parts = line.extract(format: "mem[%] = %")!
            let address = parts[0]
            let value = parts[1]
            mem1[address] = mask.apply(to: value)
            
            for address in mask.decode(address: address) {
                mem2[address] = value
            }
        }
    }
    
    solution.partOne = "\(mem1.map{ $0.value }.sum() )"
    solution.partTwo = "\(mem2.map{ $0.value }.sum() )"
    return solution
}


//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation
let execTime = TicToc(named:"Today's problems")

let input = puzzleInput

struct Block :Hashable, CustomStringConvertible{
    let width :Int
    let pixels :[Bool]
    let stringRep :String
    
    init(str:String){
        var rowCount = 1
        var pixels = [Bool]()
        for char in str {
            if char == "/" {
                rowCount+=1
            } else {
                pixels.append(char == "#")
            }
        }
        
        self.init(bools: pixels, width: rowCount)
    }
    init(bools:[Bool], width:Int) {
        self.pixels = bools
        self.width = width
        
        var str = ""
        for row in 0..<width {
            for col in 0..<width {
                str.append(pixels[row*width + col] ? "#" : ".")
            }
            str.append("\n")
        }
        stringRep = str
    }
    
    var description: String {
        return stringRep
    }
    
    static var cache22 = [String:[[Bool]]]()
    static var cache33 = [String:[[Bool]]]()
    static func cache(_ b:Block, _ i :Int) -> [[Bool]] {
        func transform(_ b:[Bool], _ t:[Int]) -> [Bool] {
            var r = [Bool]()
            for i in 0..<b.count {
                r.append(b[t[i]])
            }
            return r
        }
        func equiv2x2(_ x:[Bool]) -> [[Bool]] {
            let r = [1,3,0,2]
            let f = [1,0,3,2]
            var ret = [x]
            for _ in 1...3 { ret.append(transform(ret.last!, r)) }
            ret.append(transform(x, f))
            for _ in 1...3 { ret.append(transform(ret.last!, r)) }
            return ret
        }
        
        func equiv3x3(_ x:[Bool]) -> [[Bool]] {
            let r = [2,5,8,1,4,7,0,3,6]
            let f = [2,1,0,5,4,3,8,7,6]
            var ret = [x]
            for _ in 1...3 { ret.append(transform(ret.last!, r)) }
            ret.append(transform(x, f))
            for _ in 1...3 { ret.append(transform(ret.last!, r)) }
            return ret
        }
        if i == 2 {
            var group = Block.cache22[b.description]
            if nil == group {
                group = equiv2x2(b.pixels)
                Block.cache22[b.description] = group!
            }
            return group!
        } else if i == 3 {
            var group = Block.cache33[b.description]
            if nil == group {
                group = equiv3x3(b.pixels)
                Block.cache33[b.description] = group!
            }
            return group!
        }
        return [[]]
    }
    
    static func == (a :Block, b :Block) -> Bool {
        let w = a.width
        if w != b.width { return false }
        if a.pixels == b.pixels { return true }
        
        if w == 2 || w==3{
            let group = Block.cache(a, w)
            return group.contains(where: {$0==b.pixels})
        }
        
        return false
    }
    var hashValue :Int {
        // this is a terrible hash
        return count
        
        // this doesn't rotate
        var x = 0
        pixels.forEach { x = (x << 1) | ($0 ? 1 : 0) }
        return x
    }
    
    func split() -> [Block] {
        let newWidth = width%2==0 ? 2 : 3
        let num = squared(width/newWidth)
        if num == 1 { return [self] }
        
        var blocks = [Block]()
        for row in 0..<sqrti(num) {
            for bi in 0..<sqrti(num){
                let offset = width*newWidth*row + newWidth*bi
                var str = [Bool]()
                for col in 0..<newWidth {
                    str += pixels[offset+col*width ..< offset+col*width+newWidth]
                }
                blocks.append(Block(bools:str, width:newWidth))
            }
        }
        return blocks
    }
    static func combine(blocks:[Block]) -> Block {
        let numAcross = sqrti(blocks.count)
        let newWidth = numAcross * blocks.first!.width
        
        var rows = [[Bool]](repeating:[Bool](), count:newWidth)
        
        for bi in 0..<blocks.count {
            let b = blocks[bi]
            for row in 0..<b.width {
                rows[bi/numAcross*b.width + row] += b.pixels[b.width*row ..< b.width*(row+1)]
            }
        }
        
        return Block(bools: [Bool](rows.joined()), width: newWidth)
    }
    
    var count :Int { return pixels.filter({$0}).count }
}

class Art {
    let iteration :Int
    var picture :Block
    
    init (state:[Block], iteration:Int) {
        // list of blocks must be a square, 1,4,9,16 etc.
        self.iteration = iteration
        self.picture = Block.combine(blocks: state)
    }
    
    convenience init(state:Block, iteration:Int) {
        self.init(state:[state], iteration:iteration)
    }
    
    var width :Int { return picture.width }
    var countActivePixels :Int { return picture.count }
    
    func enhance(rules: [Block:Block]) -> Art {
        let myBlocks = picture.split()
        var newBlocks = [Block]()
        for b in myBlocks {
            newBlocks.append(rules[b]!)
        }
        return Art(state:newBlocks, iteration:iteration+1)
    }
}

// do some sanity tests on blocks
assert(Block(str:"#./.#") == Block(str:".#/#."))
assert(Block(str:".#./..#/###") == Block(str:".#./#../###"))
assert(Block(str:".#./..#/###") == Block(str:"#../#.#/##."))
assert(Block(str:".#./..#/###") == Block(str:"###/..#/.#."))
assert(Block(str:".#./..#/###").split() == [Block(str:".#./..#/###")])
assert(Block(str:".##./.#.#/####/#..#").split() == [Block(str:".#/.#"),Block(str:"#./.#"),Block(str:"##/#."),Block(str:"##/.#"),])
assert(Block.combine(blocks:[Block(str:".#/.#"),Block(str:"#./.#"),Block(str:"##/#."),Block(str:"##/.#")]) == Block(str:".##./.#.#/####/#..#"))


var blockRules = [Block:Block]()
for line in input.split(separator: "\n") {
    let blocks = line.components(separatedBy: " => ")
    blockRules[Block(str:blocks[0])] = Block(str:blocks[1])
}
var grid = Art(state: Block(str:".#./..#/###"), iteration: 0)

while grid.iteration != 18 {
    grid = grid.enhance(rules: blockRules)
    if grid.iteration == 5 {
        print("part one: \(grid.countActivePixels)") // 133
    }
}

print("part two: \(grid.countActivePixels)")  // 2221990

execTime.end()

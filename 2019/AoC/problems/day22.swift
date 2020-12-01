//
//  day22.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay22 = false

struct Deck {
    var cards :[Int]
    
    mutating func cut(_ n: Int) {
        // what about negative offset
        let offset = n > 0 ? n : cards.count - abs(n)
        let front = cards[0..<offset]
        let back = cards[offset...]
        var new = [Int]()
        new.append(contentsOf: back)
        new.append(contentsOf: front)
        cards = new
    }
    
    mutating func newStack() {
        cards = cards.reversed()
    }
    
    mutating func deal(_ increment: Int) {
        let size = cards.count
        var new = [Int](repeating: 0, count: size)
        for i in 0..<size {
            new[(i*increment)%size] = cards[i]
        }
        cards = new
    }
    
    init(size: Int = 10007) {
        cards = (0..<size).map{$0}
    }
    
    func position(of: Int) -> Int {
        return cards.firstIndex(of: of)!
    }
    
    mutating func performOps(list: [String]) {
        for line in list {
            if let params = line.extract(format: "cut %") {
                self.cut(params[0])
            } else if line == "deal into new stack" {
                self.newStack()
            } else if let params = line.extract(format: "deal with increment %") {
                self.deal(params[0])
            }
        }
    }
}

func day22 (_ input:String) -> Solution {
    var solution = Solution()
    
    var deck = Deck()
    deck.performOps(list: input.lines())
    
    solution.partOne = "\(deck.position(of: 2019))"

//    deck = Deck(size: 119315717514047)
//    deck.performOps(list: input.lines())
    
//    for _ in 0..<101741582076661 {
        // repeat first shuffle positions
//    }
    
//    solution.partTwo = "\(deck.position(of: 2020))"
    return solution
}

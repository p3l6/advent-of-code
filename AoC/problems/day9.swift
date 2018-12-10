//
//  day9.swift
//  AoC
//
//  Created by Paul Landers
//

import Foundation

let runDay9 = false

class Marble {
    var previous :Marble? = nil
    var next :Marble? = nil
    let value :Int
    init(_ value: Int) {
        self.value = value
    }
    func append(_ newNode: Marble) {
        newNode.previous = self
        newNode.next = self.next
        self.next?.previous = newNode
        self.next = newNode
    }
    func remove() {
        self.previous?.next = self.next
        self.next?.previous = self.previous
    }
}

func marbleGameHighScore(playerCount:Int, lastMarble:Int) -> Int {
    let initialMarbles = [Marble(0), Marble(1), Marble(2)]
    initialMarbles[0].next = initialMarbles[2]
    initialMarbles[2].next = initialMarbles[1]
    initialMarbles[1].next = initialMarbles[0]
    initialMarbles[0].previous = initialMarbles[1]
    initialMarbles[1].previous = initialMarbles[2]
    initialMarbles[2].previous = initialMarbles[0]
    
    var currentMarble = initialMarbles[2]
    var scores = [Int](repeating: 0, count: playerCount)
    
    for marbleValue in 3...lastMarble {
        if marbleValue % 23 == 0 {
            let currentPlayer = marbleValue % playerCount
            currentMarble = currentMarble.previous!.previous!.previous!.previous!.previous!.previous!
            let removedMarble = currentMarble.previous!
            removedMarble.remove()
            scores[currentPlayer] += marbleValue + removedMarble.value
        } else {
            let newMarble = Marble(marbleValue)
            currentMarble.next?.append(newMarble)
            currentMarble = newMarble
        }
        //        print(inPlay)
    }
    return scores.max()!
}

func day9 (_ input:String) -> Solution {
    var solution = Solution()

    let inputArray = input.extract(format: "% players; last marble is worth % points")!
    let playerCount = inputArray[0]
    let lastMarble = inputArray[1]
    
    solution.partOne = "\(marbleGameHighScore(playerCount: playerCount, lastMarble: lastMarble))"
    solution.partTwo = "\(marbleGameHighScore(playerCount: playerCount, lastMarble: 100*lastMarble))"
    return solution
}

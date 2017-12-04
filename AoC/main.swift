//
//  main.swift
//  AoC
//

// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html

import Foundation


let input = puzzleInput
"""
cat ma tac tca
cat tra rat
cat dog
"""

let phrases = input.split(separator: "\n")
var validCount = 0;

for phrase in phrases {
    var wordMap = [String:Int]()
    var valid = true
    for word in phrase.split(separator: " ") {
        if let _ = wordMap[String(word)] {
            valid = false
            break
        } else {
            wordMap[String(word)] = 1
        }
    }
    if valid {
        validCount+=1
    }
}

print("part one: \(validCount)") // 455

validCount = 0;

for phrase in phrases {
    var wordMap = [String:Int]()
    var valid = true
    for word in phrase.split(separator: " ") {
        let key = word.utf8.sorted().map({"\($0)"}).joined()
            // this ended up being a string of numbers representing the letters.
        if let _ = wordMap[key] {
            valid = false
            break
        } else {
            wordMap[key] = 1
        }
    }
    if valid {
        validCount+=1
    }
}

print("part two: \(validCount)") // 186



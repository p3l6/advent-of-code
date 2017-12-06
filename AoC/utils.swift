//
//  utils.swift
//  AoC
//

import Foundation

extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    func integerArray(_ sep: Character) -> [Int] {
        return split(separator:sep).map { Int($0)! }
    }
    
}

func squared(_ x: Int) -> Int {
    return x * x
}

class TicToc {
    var startTime :DispatchTime
    let name :String
    init(named: String) {
        startTime = DispatchTime.now()
        name = named
    }
    
    func start() {
        startTime = DispatchTime.now()
    }
    
    func end() {
        let nanoTime = DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds
        let timeInterval = nanoTime / 1_000_000
        print("\(name) took \(timeInterval) ms")
    }
}

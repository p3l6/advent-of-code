//
//  utils.swift
//  AoC
//
//  Created by Paul Landers on 11/8/18.
//

import Foundation

extension String {
    
    var length: Int {
        return self.count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(before: String) -> String {
        guard let range = self.range(of: before) else { return "" }
        return String(self[startIndex ..< range.lowerBound])
    }
    
    func substring(after: String) -> String {
        guard let range = self.range(of: after) else { return "" }
        return String(self[range.upperBound ..< endIndex])
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
        return split(separator:sep)
            .map { Int($0.trimmingCharacters(in: .whitespaces))! }
    }
    
    func stringArray(_ sep: Character, keepBlank: Bool = false) -> [String] {
        return split(separator:sep, omittingEmptySubsequences: !keepBlank)
            .map { String($0.trimmingCharacters(in: .whitespaces)) }
    }
    
    func lines(keepBlank: Bool = false) -> [String] {
        return self.stringArray("\n", keepBlank: keepBlank)
    }
    
    /// Format is a string with % where the numbers should be.
    /// If it doesnt match, nil will be returned
    /// A second, optional parameter allows specifying the wildcard character(s). Use a wildcard character that doesn't appear in the string
    func extract(format:String, wildcard :String = "%") -> [Int]? {
        let scanner = Scanner(string:self)
        var skippers = format.components(separatedBy: wildcard)
        skippers.removeLast() // the last component here is after the final wildcard
        var intList = [Int]()
        for skipper in skippers {
            scanner.charactersToBeSkipped = nil // the default here skips whitespace characters
            if skipper.count > 0 && !scanner.scanString(skipper, into: nil) {
                return nil
            }
            var thisInteger = 0
            scanner.charactersToBeSkipped = CharacterSet.whitespaces
            if scanner.scanInt(&thisInteger) {
                intList.append(thisInteger)
            } else {
                return nil
            }
        }
        return intList
    }
}

extension Character {
    var asciiValue: UInt8 {
        return UInt8(ascii: self.unicodeScalars.first!)
    }
    var lowerCase: Character {
        let ascii = self.asciiValue
        if ascii >= 97 {
            return self
        }
        return Character(UnicodeScalar(ascii + 32))
    }
}

extension Date {
    func string(format:String) -> String {
        let f = DateFormatter()
        f.dateFormat = format
        return f.string(from: self)
    }
}

extension Array {
    func count(where isIncluded: (Element) -> Bool) -> Int {
        return self.reduce(0) { isIncluded($1) ? $0 + 1 : $0 }
    }
}

extension Array where Element:Hashable{
    /// returns the first duplicate found, otherwise returns nil if all elements are unique
    func duplicate() -> Element? {
        var set = Set<Element>()
        for e in self {
            guard !set.contains(e) else {
                return e
            }
            set.insert(e)
        }
        return nil
    }
    // does not preserve order of original array!!
    // leaves one copy of any duplicates
    func removeDuplicates() -> [Element] {
        var set = Set<Element>()
        for e in self {
            guard !set.contains(e) else {
                continue
            }
            set.insert(e)
        }
        return [Element](set)
    }
}

extension Int {
    func digits() -> [Int] {
        var digits = [Int]()
        var int = self
        while int >= 10 {
            digits.append( int % 10 )
            int = int / 10
        }
        digits.append( int )
        return digits.reversed()
    }

    func squared() -> Int {
        return self * self
    }
    
    func sqrti() -> Int {
        return Int(sqrt(Double(self)))
    }
}

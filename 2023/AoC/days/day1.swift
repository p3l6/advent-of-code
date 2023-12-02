import Shared
import Foundation

@main @dayMain struct DayRunner: Runnable {
    let dayNumber = 1
    let tests = [
        TestCase("""
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
""", .one(142)),
        TestCase("""
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
""", .two(281))
    ]
}

func replaceWords(_ from: String) -> String {
    from
        .replacingOccurrences(of: "one", with: "o1e")
        .replacingOccurrences(of: "two", with: "t2o")
        .replacingOccurrences(of: "three", with: "t3e")
        .replacingOccurrences(of: "four", with: "4")
        .replacingOccurrences(of: "five", with: "5e")
        .replacingOccurrences(of: "six", with: "6")
        .replacingOccurrences(of: "seven", with: "7n")
        .replacingOccurrences(of: "eight", with: "e8t")
        .replacingOccurrences(of: "nine", with: "n9e")
}

func day(_ input: Input) -> Answer {
    var sum1 = 0
    var sum2 = 0
    for line in input.lines {
        let digits = line.unicodeScalars.filter(CharacterSet.decimalDigits.contains)
        sum1 += Int("\(digits.first ?? "0")\(digits.last ?? "0")") ?? 0

        let digits2 = replaceWords(line).unicodeScalars.filter(CharacterSet.decimalDigits.contains)
        sum2 += Int("\(digits2.first!)\(digits2.last!)")!
    }

    return .one(sum1) + .two(sum2)
}


import Foundation
import Shared

@main @dayMain struct DayRunner: Runnable {
    let dayNumber = 2
    let tests = [
        TestCase("""
 7 6 4 2 1
 1 2 7 8 9
 9 7 6 2 1
 1 3 2 4 5
 8 6 4 4 1
 1 3 6 7 9
 """, .one(2) + .two(4))
    ]
}

func firstUnsafeLevel(report: [Int], skippingIndex: Int? = nil) -> Int? {
    var last: Int? = nil
    var increasing: Bool? = nil
    for (idx, level) in report.enumerated() {
        if idx == skippingIndex { continue }

        if let last {
            let diff = abs(last - level)
            let levelIncreases = level > last

            if diff > 3 || diff < 1 { return idx }

            if let increasing {
                if levelIncreases != increasing { return idx }
            } else {
                increasing = levelIncreases
            }
        }

        last = level
    }
    return nil
}

func day(_ input: Input) -> Answer {
    let reports = input.lines.map(\.ints)
    let unsafeLevels = reports.map { firstUnsafeLevel(report: $0) }
    let safeReports = unsafeLevels.filter{ $0 == nil }

    let dampenedSafeReports = zip(reports, unsafeLevels)
        .filter{ $0.1 != nil }
        .filter{
            firstUnsafeLevel(report: $0.0, skippingIndex: $0.1) == nil ||
            firstUnsafeLevel(report: $0.0, skippingIndex: $0.1! - 1) == nil ||
            firstUnsafeLevel(report: $0.0, skippingIndex: $0.1! - 2) == nil 
        }

    return .one(safeReports.count) + .two(safeReports.count + dampenedSafeReports.count)
}

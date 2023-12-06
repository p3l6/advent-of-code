import Foundation
import Shared

@main @dayMain struct DayRunner: Runnable {
    let dayNumber = 6
    let tests = [
        TestCase("""
Time:      7  15   30
Distance:  9  40  200
""", .both(288, 71503))
    ]
}

/// solves for t where:  `distance = t * ( time - t )`
/// Rounds results to centered integers, providing a range that will beat the distance provided
func quadratic(time: Int, distance: Int) -> (Int, Int) {
    let plusMinus = sqrt(Double(time * time - 4 * distance))
    let smallRoot = ((Double(time) - plusMinus) / 2.0)
    let largeRoot = ((Double(time) + plusMinus) / 2.0)

    return (
        Int((smallRoot + 1).rounded(.down)),
        Int((largeRoot - 1).rounded(.up))
    )
}

func day(_ input: Input) -> Answer {
    let lines = input.lines
    let times = lines[0].trimmingPrefix(/Time: +/).split(separator: /\ +/).map { Int($0)! }
    let dists = lines[1].trimmingPrefix(/Distance: +/).split(separator: /\ +/).map { Int($0)! }

    let races = zip(times, dists)
    let roots = races.map { quadratic(time: $0.0, distance: $0.1) }
    let partOne = roots.map { 1 + $0.1 - $0.0 }.product

    let time = Int(lines[0].trimmingPrefix(/Time: +/).replacing(" ", with: ""))!
    let dist = Int(lines[1].trimmingPrefix(/Distance: +/).replacing(" ", with: ""))!
    let roots2 = quadratic(time: time, distance: dist)
    let partTwo = 1 + roots2.1 - roots2.0

    return .one(partOne) + .two(partTwo)
}

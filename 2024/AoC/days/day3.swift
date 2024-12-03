import Foundation
import Shared

@main @dayMain struct DayRunner: Runnable {
    let dayNumber = 3
    let tests = [
        TestCase("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))",
                 .one(161)),
        TestCase("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))",
                 .two(48))
    ]
}

func day(_ input: Input) -> Answer {
    let mult = /mul\((\d+),(\d+)\)/
    let memory = input.string
    let validInstructions = memory.matches(of: mult)

    let part1 = validInstructions
        .map { Int($0.1)! * Int($0.2)! }
        .sum

    let enabledMemory = memory
        .split(separator: "do()")
        .map { $0.split(separator: "don't()").first! }
        .joined()
    let part2 = enabledMemory.matches(of: mult)
        .map { Int($0.1)! * Int($0.2)! }
        .sum


    return .one(part1) + .two(part2)
}

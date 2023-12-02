import Foundation

@attached(member, names: named(`main`), named(answeringFunc))
public macro dayMain() = #externalMacro(module: "RunnerMacro", type: "RunnerMacro")

public protocol Runnable {
    var dayNumber: Int { get }
    func runDay() async
    var answeringFunc: (Input) -> Answer { get }
    var tests: [TestCase] { get }
}

public extension Runnable {
    func runDay() async {
        let failingTests = tests
            .enumerated()
            .map { (i, t) in (i, t, answeringFunc(Input(string: t.input))) }
            .filter { (i, t, a) in a != t.answer }

        failingTests.forEach { (i, t, a) in print("Test Case \(i):\n Expected \(t.answer)\n But Got  \(a)") }

        if failingTests.isEmpty {
            print("All tests passed.")
            let input = await fetchInput(num: dayNumber)
            let answer = answeringFunc(Input(string: input))
            print("Answer: \(answer)")
        }
    }
}

public struct Input {
    public let string: String

    public var lines: [String] {
        string.split(separator: "\n").map{ String($0.trimmingCharacters(in: .whitespacesAndNewlines)) }
    }


    // inputSplit(on:) -> [String]
    // inputFromRegexLines -> [String]
    // inputFromLines -> [String]
    // inputAsIntGrid
    // inputAsCharGrid

}

public struct Answer: Equatable, CustomStringConvertible {
    public enum Part: CustomStringConvertible {
        case skipped
        case string(String)
        case int(Int)

        public static func ~= (lhs: Part, rhs: Part) -> Bool {
            switch (lhs, rhs) {
            case (.skipped, _), (_, .skipped): true
            case let (.string(a), .string(b)): a == b
            case let (.int(a), .int(b)): a == b
            case let (.string(a), .int(b)): a == String(b)
            case let (.int(a), .string(b)): String(a) == b
            }
        }

        public var description: String {
            switch self {
            case .skipped: "<-?->"
            case let .int(x): String(x)
            case let .string(s): s
            }
        }
    }

    public let one: Part
    public let two: Part

    public init(_ one: Part, _ two: Part) { self.one = one; self.two = two }
    public static func one(_ one: String) -> Answer { Answer(.string(one), .skipped) }
    public static func one(_ one: Int) -> Answer { Answer(.int(one), .skipped) }
    public static func two(_ two: String) -> Answer { Answer(.skipped, .string(two)) }
    public static func two(_ two: Int) -> Answer { Answer(.skipped, .int(two)) }
    public static func both(_ one: Int, _ two: Int) -> Answer { Answer(.int(one), .int(two)) }
    public static func both(_ one: String, _ two: String) -> Answer { Answer(.string(one), .string(two)) }

    public var description: String {
        return "| \(one) | \(two) |"
    }

    public static func == (lhs: Answer, rhs: Answer) -> Bool {
        lhs.one ~= rhs.one && lhs.two ~= rhs.two
    }

    public static func + (lhs: Answer, rhs: Answer) -> Answer {
        let one = if case .skipped = lhs.one { rhs.one } else { lhs.one }
        let two = if case .skipped = lhs.two { rhs.two } else { lhs.two }
        return Answer(one, two)
    }
}

public struct TestCase {
    let input: String
    let answer: Answer

    public init(_ input: String, _ answer: Answer) {
        self.input = input
        self.answer = answer
    }
}

func fetchInput(num: Int) async -> String {
    let archiveFile = URL(fileURLWithPath: FileManager().currentDirectoryPath).appendingPathComponent("input").appendingPathComponent("input_\(num).txt")
    if let contents = try? String(contentsOf: archiveFile, encoding: .utf8) {
        return contents
    }

    let url = URL(string: "https://adventofcode.com/\(YEAR)/day/\(num)/input")!
    print("Fetching input: \(url)")

    var request = URLRequest(url: url)
    request.addValue("github.com/p3l6/advent-of-code via swift and URLSession", forHTTPHeaderField: "User-Agent")
    request.addValue("session=\(TOKEN)", forHTTPHeaderField: "cookie")
    let (data, _) = try! await URLSession.shared.data(for: request)
    let contents = String(data: data, encoding: .utf8)!

    try! FileManager.default.createDirectory(at: archiveFile.deletingLastPathComponent(), withIntermediateDirectories: true)
    try! data.write(to: archiveFile)
    return contents
}

public extension [Int] {
    var sum: Int {
        reduce(0) { (acc, x) in acc + x }
    }
}

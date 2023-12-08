// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "AoC",
    platforms: [.macOS(.v14)],
    dependencies: [.package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0")],
    targets: [
        .macro(name:"RunnerMacro", 
               dependencies: [.product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                              .product(name: "SwiftCompilerPlugin", package: "swift-syntax")], 
               path: ".", sources: ["DayRunnerMacro.swift"]),
        .target(name: "Shared", dependencies: ["RunnerMacro"], path: ".", sources: ["shared.swift", "config.swift", "grid.swift"]),

        .executableTarget(name: "day1", dependencies:["Shared"], path: "days", sources: ["day1.swift"]),
        .executableTarget(name: "day2", dependencies:["Shared"], path: "days", sources: ["day2.swift"]),
        .executableTarget(name: "day3", dependencies:["Shared"], path: "days", sources: ["day3.swift"]),
        .executableTarget(name: "day4", dependencies:["Shared"], path: "days", sources: ["day4.swift"]),
        .executableTarget(name: "day5", dependencies:["Shared"], path: "days", sources: ["day5.swift"]),
        .executableTarget(name: "day6", dependencies:["Shared"], path: "days", sources: ["day6.swift"]),
        .executableTarget(name: "day7", dependencies:["Shared"], path: "days", sources: ["day7.swift"]),
    ]
)

for target in package.targets {
    target.swiftSettings = (target.swiftSettings ?? [SwiftSetting]()) + [.enableUpcomingFeature("BareSlashRegexLiterals")]
}

/* DAY TEMPLATE

import Foundation
import Shared

@main @dayMain struct DayRunner: Runnable {
    let dayNumber = 
    let tests = [
        TestCase("""
 """, .one(6))
    ]
}

func day(_ input: Input) -> Answer {

    return .one(5) //  + .two(7)
}

 */

//
//  AocTest.swift
//  AocTest
//
//  Created by Paul Landers on 11/13/18.
//

import XCTest

class AocTest: XCTestCase {
    struct Case { var input:String; var p1:String?; var p2:String?}
    var examples :[Case] { return []}
    var problem :Problem { return day1 }
    func testAll() {
        for ex in examples {
            let sol = problem(ex.input)
            if let p1 = ex.p1, p1.count > 0 {
                XCTAssertEqual(sol.partOne, p1)
            }
            if let p2 = ex.p2, p2.count > 0 {
                XCTAssertEqual(sol.partTwo, p2)
            }
        }
    }
}

// Case(input:"", p1:"", p2:""),
// Case(input:"""
// """, p1:"", p2:""),

class Day1Tests: AocTest { override var problem:Problem{return day1}; override var examples :[Case] { return [
Case(input:"""
1721
979
366
299
675
1456
""", p1:"514579", p2:"241861950"),
]}}

class Day2Tests: AocTest { override var problem:Problem{return day2}; override var examples :[Case] { return [
Case(input:"""
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
""", p1:"2", p2:"1"),
]}}

class Day3Tests: AocTest { override var problem:Problem{return day3}; override var examples :[Case] { return [
Case(input:"""
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
""", p1:"7", p2:"336"),
]}}

class Day4Tests: AocTest { override var problem:Problem{return day4}; override var examples :[Case] { return [
Case(input:"""
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
""", p1:"2", p2:""),
]}
    func testValidator() {
        XCTAssertTrue(Passport(data: "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980 hcl:#623a2f").valid)
    }
}

class Day5Tests: AocTest { override var problem:Problem{return day5}; override var examples :[Case] { return []}
    func testSeats() {
        XCTAssertEqual(357, Seat("FBFBBFFRLR").id)
        XCTAssertEqual(567, Seat("BFFFBBFRRR").id)
        XCTAssertEqual(119, Seat("FFFBBBFRRR").id)
        XCTAssertEqual(820, Seat("BBFFBBFRLL").id)
    }
}

// class Day6Tests: AocTest { override var problem:Problem{return day6}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

// class Day7Tests: AocTest { override var problem:Problem{return day7}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

// class Day8Tests: AocTest { override var problem:Problem{return day8}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

// class Day9Tests: AocTest { override var problem:Problem{return day9}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

// class Day10Tests: AocTest { override var problem:Problem{return day10}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

// class Day11Tests: AocTest { override var problem:Problem{return day11}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

// class Day12Tests: AocTest { override var problem:Problem{return day12}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

// class Day13Tests: AocTest { override var problem:Problem{return day13}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

// class Day14Tests: AocTest { override var problem:Problem{return day14}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

// class Day15Tests: AocTest { override var problem:Problem{return day15}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

// class Day16Tests: AocTest { override var problem:Problem{return day16}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

// class Day17Tests: AocTest { override var problem:Problem{return day17}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

// class Day18Tests: AocTest { override var problem:Problem{return day18}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

// class Day19Tests: AocTest { override var problem:Problem{return day19}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

// class Day20Tests: AocTest { override var problem:Problem{return day20}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

// class Day21Tests: AocTest { override var problem:Problem{return day21}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

// class Day22Tests: AocTest { override var problem:Problem{return day22}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

// class Day23Tests: AocTest { override var problem:Problem{return day23}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

// class Day24Tests: AocTest { override var problem:Problem{return day24}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

// class Day25Tests: AocTest { override var problem:Problem{return day25}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}


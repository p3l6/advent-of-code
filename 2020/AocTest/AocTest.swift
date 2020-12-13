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

class Day6Tests: AocTest { override var problem:Problem{return day6}; override var examples :[Case] { return [
Case(input:"""
abc

a
b
c

ab
ac

a
a
a
a

b
""", p1:"11", p2:"6"),
]}}

class Day7Tests: AocTest { override var problem:Problem{return day7}; override var examples :[Case] { return [
Case(input:"""
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
""", p1:"4", p2:"32"),
Case(input:"""
shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.
""", p1:"", p2:"126"),
]}}

class Day8Tests: AocTest { override var problem:Problem{return day8}; override var examples :[Case] { return [
Case(input:"""
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
""", p1:"5", p2:"8"),
]}}

// class Day9Tests: AocTest { override var problem:Problem{return day9}; override var examples :[Case] { return [
// Case(input:"""
// """, p1:"", p2:""),
// ]}}

class Day10Tests: AocTest { override var problem:Problem{return day10}; override var examples :[Case] { return [
Case(input:"""
16
10
15
5
1
11
7
19
6
12
4
""", p1:"35", p2:"8"),
Case(input:"""
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
""", p1:"220", p2:"19208"),
]}}

class Day11Tests: AocTest { override var problem:Problem{return day11}; override var examples :[Case] { return [
Case(input:"""
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
""", p1:"37", p2:"26"),
]}}

class Day12Tests: AocTest { override var problem:Problem{return day12}; override var examples :[Case] { return [
Case(input:"""
F10
N3
F7
R90
F11
""", p1:"25", p2:"286"),
]}}

class Day13Tests: AocTest { override var problem:Problem{return day13}; override var examples :[Case] { return [
Case(input:"1\n17,x,13,19", p1:"", p2:"3417"),
Case(input:"""
939
7,13,x,x,59,x,31,19
""", p1:"295", p2:"1068781"),
]}}

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


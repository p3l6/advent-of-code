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

class Day1Tests: AocTest { override var problem:Problem{return day1}; override var examples :[Case] { return [
    Case(input:"+1\n-2\n+3\n1", p1:"3", p2:"2"),
    Case(input:"+3\n+3\n+4\n-2\n-4", p1:"", p2:"10"),
    ]}}
class Day2Tests: AocTest { override var problem:Problem{return day2}; override var examples :[Case] { return [
    Case(input:"abcdef\nbababc\nabbcde\nabcccd\naabcdd\nabcdee\nababab", p1:"12", p2:""),
    Case(input:"""
    abcde
    fghij
    klmno
    pqrst
    fguij
    axcye
    wvxyz
    """, p1:"", p2:"fgij"),
    ]}}
class Day3Tests: AocTest { override var problem:Problem{return day3}; override var examples :[Case] { return [
    Case(input:"""
    #1 @ 1,2: 4x5
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2
    """, p1:"6", p2:""),
    ]}}
class Day4Tests: AocTest { override var problem:Problem{return day4}; override var examples :[Case] { return [
    Case(input:"""
    [1518-11-01 00:00] Guard #10 begins shift
    [1518-11-01 00:05] falls asleep
    [1518-11-01 00:25] wakes up
    [1518-11-01 00:30] falls asleep
    [1518-11-03 00:24] falls asleep
    [1518-11-01 00:55] wakes up
    [1518-11-01 23:58] Guard #99 begins shift
    [1518-11-02 00:40] falls asleep
    [1518-11-02 00:50] wakes up
    [1518-11-03 00:29] wakes up
    [1518-11-03 00:05] Guard #10 begins shift
    [1518-11-04 00:02] Guard #99 begins shift
    [1518-11-04 00:36] falls asleep
    [1518-11-04 00:46] wakes up
    [1518-11-05 00:03] Guard #99 begins shift
    [1518-11-05 00:45] falls asleep
    [1518-11-05 00:55] wakes up
    """, p1:"240", p2:"4455"),
    ]}}
class Day5Tests: AocTest { override var problem:Problem{return day5}; override var examples :[Case] { return [
    Case(input:"dabAcCaCBAcCcaDA", p1:"10", p2:"4"),
    Case(input:"aA", p1:"0", p2:""),
    Case(input:"abBA", p1:"0", p2:""),
    Case(input:"abAB", p1:"4", p2:""),
    Case(input:"aabAAB", p1:"6", p2:""),
    ]}}
class Day6Tests: AocTest { override var problem:Problem{return day6}; override var examples :[Case] { return [
    Case(input:"""
    1, 1
    1, 6
    8, 3
    3, 4
    5, 5
    8, 9
    """, p1:"17", p2:"110"),
    ]}}
class Day7Tests: AocTest { override var problem:Problem{return day7}; override var examples :[Case] { return [
    Case(input:"""
    Step C must be finished before step A can begin.
    Step C must be finished before step F can begin.
    Step A must be finished before step B can begin.
    Step A must be finished before step D can begin.
    Step B must be finished before step E can begin.
    Step D must be finished before step E can begin.
    Step F must be finished before step E can begin.
    """, p1:"CABDFE", p2:""),
    ]}}
class Day8Tests: AocTest { override var problem:Problem{return day8}; override var examples :[Case] { return [
    Case(input:"2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2", p1:"138", p2:"66"),
    ]}}
class Day9Tests: AocTest { override var problem:Problem{return day9}; override var examples :[Case] { return [
    Case(input:"9 players; last marble is worth 25 points", p1:"32", p2:""),
    Case(input:"10 players; last marble is worth 1618 points", p1:"8317", p2:""),
    Case(input:"13 players; last marble is worth 7999 points", p1:"146373", p2:""),
    Case(input:"17 players; last marble is worth 1104 points", p1:"2764", p2:""),
    Case(input:"21 players; last marble is worth 6111 points", p1:"54718", p2:""),
    Case(input:"30 players; last marble is worth 5807 points", p1:"37305", p2:""),
    ]}}
class Day10Tests: AocTest { override var problem:Problem{return day10}; override var examples :[Case] { return [
    Case(input:"""
    position=< 9,  1> velocity=< 0,  2>
    position=< 7,  0> velocity=<-1,  0>
    position=< 3, -2> velocity=<-1,  1>
    position=< 6, 10> velocity=<-2, -1>
    position=< 2, -4> velocity=< 2,  2>
    position=<-6, 10> velocity=< 2, -2>
    position=< 1,  8> velocity=< 1, -1>
    position=< 1,  7> velocity=< 1,  0>
    position=<-3, 11> velocity=< 1, -2>
    position=< 7,  6> velocity=<-1, -1>
    position=<-2,  3> velocity=< 1,  0>
    position=<-4,  3> velocity=< 2,  0>
    position=<10, -3> velocity=<-1,  1>
    position=< 5, 11> velocity=< 1, -2>
    position=< 4,  7> velocity=< 0, -1>
    position=< 8, -2> velocity=< 0,  1>
    position=<15,  0> velocity=<-2,  0>
    position=< 1,  6> velocity=< 1,  0>
    position=< 8,  9> velocity=< 0, -1>
    position=< 3,  3> velocity=<-1,  1>
    position=< 0,  5> velocity=< 0, -1>
    position=<-2,  2> velocity=< 2,  0>
    position=< 5, -2> velocity=< 1,  2>
    position=< 1,  4> velocity=< 2,  1>
    position=<-2,  7> velocity=< 2, -2>
    position=< 3,  6> velocity=<-1, -1>
    position=< 5,  0> velocity=< 1,  0>
    position=<-6,  0> velocity=< 2,  0>
    position=< 5,  9> velocity=< 1, -2>
    position=<14,  7> velocity=<-2,  0>
    position=<-3,  6> velocity=< 2, -1>
    """, p1:"", p2:"3"),
    ]}}
class Day11Tests: AocTest { override var problem:Problem{return day11}; override var examples :[Case] { return [
    Case(input:"18", p1:"33,45", p2:"90,269,16"),
    ]}}
class Day12Tests: AocTest { override var problem:Problem{return day12}; override var examples :[Case] { return [
    Case(input:"""
    initial state: #..#.#..##......###...###

    ..... => .
    ....# => .
    ...#. => .
    ...## => #
    ..#.. => #
    ..#.# => .
    ..##. => .
    ..### => .
    .#... => #
    .#..# => .
    .#.#. => #
    .#.## => #
    .##.. => #
    .##.# => .
    .###. => .
    .#### => #
    #.... => .
    #...# => .
    #..#. => .
    #..## => .
    #.#.. => .
    #.#.# => #
    #.##. => .
    #.### => #
    ##... => .
    ##..# => .
    ##.#. => #
    ##.## => #
    ###.. => #
    ###.# => #
    ####. => #
    ##### => .
    """, p1:"325", p2:""),
    ]}}
class Day13Tests: AocTest { override var problem:Problem{return day13}; override var examples :[Case] { return [
    Case(input:"""
    /->-\\
    |   |  /----\\
    | /-+--+-\\  |
    | | |  | v  |
    \\-+-/  \\-+--/
      \\------/
    """, p1:"7,3", p2:""),
    ]}
    func testTurn() {
        let cart = Railway.Cart(pos: Point(2,2), dir:.north)
        cart.turnAtIntersection(); XCTAssertEqual(Direction.west, cart.direction )
        cart.turnAtIntersection(); XCTAssertEqual(Direction.west, cart.direction )
        cart.turnAtIntersection(); XCTAssertEqual(Direction.north, cart.direction )
        cart.turnAtIntersection(); XCTAssertEqual(Direction.west, cart.direction )
        cart.turnAtIntersection(); XCTAssertEqual(Direction.west, cart.direction )
        cart.turnAtIntersection(); XCTAssertEqual(Direction.north, cart.direction )
    }
}
class Day14Tests: AocTest { override var problem:Problem{return day14}; override var examples :[Case] { return [
    Case(input:"9", p1:"5158916779", p2:""),
    Case(input:"5", p1:"0124515891", p2:""),
    Case(input:"18", p1:"9251071085", p2:""),
    Case(input:"2018", p1:"5941429882", p2:""),
    Case(input:"51589", p1:"", p2:"9"),
//    Case(input:"01245", p1:"", p2:"5"), TODO bug when numbers start with 0
    Case(input:"92510", p1:"", p2:"18"),
    Case(input:"59414", p1:"", p2:"2018"),
    Case(input:"15891", p1:"", p2:"10"),
    ]}}
class Day15Tests: AocTest { override var problem:Problem{return day15}; override var examples :[Case] { return [
    Case(input:"""
    #######
    #.G...#
    #...EG#
    #.#.#G#
    #..G#E#
    #.....#
    #######
    """, p1:"27730", p2:"4988"),
    Case(input:"""
    #######
    #G..#E#
    #E#E.E#
    #G.##.#
    #...#E#
    #...E.#
    #######
    """, p1:"36334", p2:""),
    Case(input:"""
    #######
    #E..EG#
    #.#G.E#
    #E.##E#
    #G..#.#
    #..E#.#
    #######
    """, p1:"39514", p2:"31284"),
    Case(input:"""
    #######
    #E.G#.#
    #.#G..#
    #G.#.G#
    #G..#.#
    #...E.#
    #######
    """, p1:"27755", p2:"3478"),
    Case(input:"""
    #######
    #.E...#
    #.#..G#
    #.###.#
    #E#G#G#
    #...#G#
    #######
    """, p1:"28944", p2:""),
    Case(input:"""
    #########
    #G......#
    #.E.#...#
    #..##..G#
    #...##..#
    #...#...#
    #.G...G.#
    #.....G.#
    #########
    """, p1:"18740", p2:"1140"),
    ]}}
class Day16Tests: AocTest { override var problem:Problem{return day16}; override var examples :[Case] { return [
/// test case is an infinite loop for part two
//    Case(input:"""
//    Before: [3, 2, 1, 1]
//    9 2 1 2
//    After:  [3, 2, 2, 1]
//
//    Before: [3, 2, 1, 1]
//    9 2 1 2
//    After:  [3, 2, 2, 1]
//
//
//    3 0 2 1
//    2 1 3 4
//    """, p1:"2", p2:""),
    ]}}
class Day17Tests: AocTest { override var problem:Problem{return day17}; override var examples :[Case] { return [
    Case(input:"""
    x=495, y=2..7
    y=7, x=495..501
    x=501, y=3..7
    x=498, y=2..4
    x=506, y=1..2
    x=498, y=10..13
    x=504, y=10..13
    y=13, x=498..504
    """, p1:"57", p2:"29"),
    ]}}
class Day18Tests: AocTest { override var problem:Problem{return day18}; override var examples :[Case] { return [
    Case(input:"""
    .#.#...|#.
    .....#|##|
    .|..|...#.
    ..|#.....#
    #.#|||#|#|
    ...#.||...
    .|....|...
    ||...#|.#|
    |.||||..|.
    ...#.|..|.
    """, p1:"1147", p2:""),
    ]}}
class Day19Tests: AocTest { override var problem:Problem{return day19}; override var examples :[Case] { return [
    Case(input:"""
    #ip 0
    seti 5 0 1
    seti 6 0 2
    addi 0 1 0
    addr 1 2 3
    setr 1 0 0
    seti 8 0 4
    seti 9 0 5
    """, p1:"6", p2:""),
    ]}}
class Day20Tests: AocTest { override var problem:Problem{return day20}; override var examples :[Case] { return [
    Case(input:"^WNE$", p1:"3", p2:""),
    Case(input:"^ENWWW(NEEE|SSE(EE|N))$", p1:"10", p2:""),
    Case(input:"^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$", p1:"18", p2:""),
    Case(input:"^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$", p1:"23", p2:""),
    Case(input:"^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$", p1:"31", p2:""),
    ]}}
class Day22Tests: AocTest { override var problem:Problem{return day22}; override var examples :[Case] { return [
    Case(input:"depth: 510\ntarget: 10,10", p1:"114", p2:"45"),
    ]}}
class Day23Tests: AocTest { override var problem:Problem{return day23}; override var examples :[Case] { return [
    Case(input:"""
    pos=<0,0,0>, r=4
    pos=<1,0,0>, r=1
    pos=<4,0,0>, r=3
    pos=<0,2,0>, r=1
    pos=<0,5,0>, r=3
    pos=<0,0,3>, r=1
    pos=<1,1,1>, r=1
    pos=<1,1,2>, r=1
    pos=<1,3,1>, r=1
    """, p1:"7", p2:""),
    Case(input:"""
    pos=<10,12,12>, r=2
    pos=<12,14,12>, r=2
    pos=<16,12,12>, r=4
    pos=<14,14,14>, r=6
    pos=<50,50,50>, r=200
    pos=<10,10,10>, r=5
    """, p1:"", p2:"36"),
    ]}}
class Day24Tests: AocTest { override var problem:Problem{return day24}; override var examples :[Case] { return [
    Case(input:"""
    Immune System:
    17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2
    989 units each with 1274 hit points (immune to fire; weak to bludgeoning, slashing) with an attack that does 25 slashing damage at initiative 3

    Infection:
    801 units each with 4706 hit points (weak to radiation) with an attack that does 116 bludgeoning damage at initiative 1
    4485 units each with 2961 hit points (immune to radiation; weak to fire, cold) with an attack that does 12 slashing damage at initiative 4
    """, p1:"5216", p2:"51"),
    ]}}
class Day25Tests: AocTest { override var problem:Problem{return day25}; override var examples :[Case] { return [
    Case(input:"""
    -1,2,2,0
    0,0,2,-2
    0,0,0,-2
    -1,2,0,0
    -2,-2,-2,2
    3,0,2,-1
    -1,3,2,2
    -1,0,-1,0
    0,2,1,-2
    3,0,0,0
    """, p1:"4", p2:""),
    ]}}


class UtilsTest: XCTestCase {
    func testExtract() {
        XCTAssertEqual("#1 @ 1,3: 4x4".extract(format:"#% @ %,%: %x%"),
                       [1,1,3,4,4])
    }
    
    func testCharacter() {
        XCTAssertEqual(Character("A").asciiValue, 65)
        XCTAssertEqual(Character("a").asciiValue, 97)
        XCTAssertEqual(Character("A").lowerCase, "a")
        XCTAssertEqual(Character("A").lowerCase, Character("a").lowerCase)
        XCTAssertEqual(Character("b").lowerCase, "b")
        XCTAssertEqual(Character("X").lowerCase, Character("x"))
    }
    
    func testDigits() {
        XCTAssertEqual(123.digits(), [1,2,3])
        XCTAssertEqual(10.digits(), [1,0])
        XCTAssertEqual(6.digits(), [6])
        XCTAssertEqual(647832.digits(), [6,4,7,8,3,2])
    }
}


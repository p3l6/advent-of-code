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
    //Case(input:"", p1:"", p2:""),
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
    //Case(input:"", p1:"", p2:""),
    ]}}
class Day12Tests: AocTest { override var problem:Problem{return day12}; override var examples :[Case] { return [
    //Case(input:"", p1:"", p2:""),
    ]}}
class Day13Tests: AocTest { override var problem:Problem{return day13}; override var examples :[Case] { return [
    //Case(input:"", p1:"", p2:""),
    ]}}
class Day14Tests: AocTest { override var problem:Problem{return day14}; override var examples :[Case] { return [
    //Case(input:"", p1:"", p2:""),
    ]}}
class Day15Tests: AocTest { override var problem:Problem{return day15}; override var examples :[Case] { return [
    //Case(input:"", p1:"", p2:""),
    ]}}
class Day16Tests: AocTest { override var problem:Problem{return day16}; override var examples :[Case] { return [
    //Case(input:"", p1:"", p2:""),
    ]}}
class Day17Tests: AocTest { override var problem:Problem{return day17}; override var examples :[Case] { return [
    //Case(input:"", p1:"", p2:""),
    ]}}
class Day18Tests: AocTest { override var problem:Problem{return day18}; override var examples :[Case] { return [
    //Case(input:"", p1:"", p2:""),
    ]}}
class Day19Tests: AocTest { override var problem:Problem{return day19}; override var examples :[Case] { return [
    //Case(input:"", p1:"", p2:""),
    ]}}
class Day20Tests: AocTest { override var problem:Problem{return day20}; override var examples :[Case] { return [
    //Case(input:"", p1:"", p2:""),
    ]}}
class Day21Tests: AocTest { override var problem:Problem{return day21}; override var examples :[Case] { return [
    //Case(input:"", p1:"", p2:""),
    ]}}
class Day22Tests: AocTest { override var problem:Problem{return day22}; override var examples :[Case] { return [
    //Case(input:"", p1:"", p2:""),
    ]}}
class Day23Tests: AocTest { override var problem:Problem{return day23}; override var examples :[Case] { return [
    //Case(input:"", p1:"", p2:""),
    ]}}
class Day24Tests: AocTest { override var problem:Problem{return day24}; override var examples :[Case] { return [
    //Case(input:"", p1:"", p2:""),
    ]}}
class Day25Tests: AocTest { override var problem:Problem{return day25}; override var examples :[Case] { return [
    //Case(input:"", p1:"", p2:""),
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
}


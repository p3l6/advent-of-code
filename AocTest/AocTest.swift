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
12
14
1969
""", p1:"658", p2:"970"),
    ]}}
//class Day2Tests: AocTest { override var problem:Problem{return day2}; override var examples :[Case] { return [
//    ]}}
//class Day3Tests: AocTest { override var problem:Problem{return day3}; override var examples :[Case] { return [
//    ]}}
//class Day4Tests: AocTest { override var problem:Problem{return day4}; override var examples :[Case] { return [
//    ]}}
//class Day5Tests: AocTest { override var problem:Problem{return day5}; override var examples :[Case] { return [
//    ]}}
//class Day6Tests: AocTest { override var problem:Problem{return day6}; override var examples :[Case] { return [
//    ]}}
//class Day7Tests: AocTest { override var problem:Problem{return day7}; override var examples :[Case] { return [
//    ]}}
//class Day8Tests: AocTest { override var problem:Problem{return day8}; override var examples :[Case] { return [
//    ]}}
//class Day9Tests: AocTest { override var problem:Problem{return day9}; override var examples :[Case] { return [
//    ]}}
//class Day10Tests: AocTest { override var problem:Problem{return day10}; override var examples :[Case] { return [
//    ]}}
//class Day11Tests: AocTest { override var problem:Problem{return day11}; override var examples :[Case] { return [
//    ]}}
//class Day12Tests: AocTest { override var problem:Problem{return day12}; override var examples :[Case] { return [
//    ]}}
//class Day13Tests: AocTest { override var problem:Problem{return day13}; override var examples :[Case] { return [
//    ]}}
//class Day14Tests: AocTest { override var problem:Problem{return day14}; override var examples :[Case] { return [
//    ]}}
//class Day15Tests: AocTest { override var problem:Problem{return day15}; override var examples :[Case] { return [
//    ]}}
//class Day16Tests: AocTest { override var problem:Problem{return day16}; override var examples :[Case] { return [
//    ]}}
//class Day17Tests: AocTest { override var problem:Problem{return day17}; override var examples :[Case] { return [
//    ]}}
//class Day18Tests: AocTest { override var problem:Problem{return day18}; override var examples :[Case] { return [
//    ]}}
//class Day19Tests: AocTest { override var problem:Problem{return day19}; override var examples :[Case] { return [
//    ]}}
//class Day20Tests: AocTest { override var problem:Problem{return day20}; override var examples :[Case] { return [
//    ]}}
//class Day22Tests: AocTest { override var problem:Problem{return day22}; override var examples :[Case] { return [
//    ]}}
//class Day23Tests: AocTest { override var problem:Problem{return day23}; override var examples :[Case] { return [
//    ]}}
//class Day24Tests: AocTest { override var problem:Problem{return day24}; override var examples :[Case] { return [
//    ]}}
//class Day25Tests: AocTest { override var problem:Problem{return day25}; override var examples :[Case] { return [
//    ]}}

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


//
//  AocTest.swift
//  AocTest
//
//  Created by Paul Landers on 11/13/18.
//

import XCTest

class AocTest: XCTestCase {
    override func setUp() {}
    override func tearDown() {}
    struct Case { var input:String; var p1:String?; var p2:String?}
    
    let examples = [
//        Case(input:"", p1:"", p2:""),
        Case(input:"dabAcCaCBAcCcaDA", p1:"10", p2:"4"),
        Case(input:"aA", p1:"0", p2:""),
        Case(input:"abBA", p1:"0", p2:""),
        Case(input:"abAB", p1:"4", p2:""),
        Case(input:"aabAAB", p1:"6", p2:""),
    ]
    
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


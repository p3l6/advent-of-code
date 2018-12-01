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
//        Case(input:"+1\n+1\n+1", p1:"3", p2:""),
//        Case(input:"-1\n-2\n-3", p1:"-6", p2:""),
        Case(input:"+1\n-2\n+3\n1", p1:"3", p2:"2"),
        Case(input:"+3\n+3\n+4\n-2\n-4", p1:"", p2:"10"),
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


//
//  MathTests.swift
//  paintsplashTests
//
//  Created by admin on 3/4/21.
//

import XCTest
@testable import paintsplash

class MathTests: XCTestCase {

    func testGetGCD_array() {
        var numbers = [6,8,4]
        XCTAssertEqual(Math.getGCD(numbers: numbers), 2)
        
        numbers = [4,8,16]
        XCTAssertEqual(Math.getGCD(numbers: numbers), 4)
        
        numbers = [16,0,0,16]
        XCTAssertEqual(Math.getGCD(numbers: numbers), 16)

        numbers = [8,4,2,1]
        XCTAssertEqual(Math.getGCD(numbers: numbers), 1)

        numbers = [17]
        XCTAssertEqual(Math.getGCD(numbers: numbers), 17)
        
        numbers = [3, 5]
        XCTAssertEqual(Math.getGCD(numbers: numbers), 1)

        numbers = [0]
        XCTAssertEqual(Math.getGCD(numbers: numbers), 0)
    }
    
    func testGetGCD_twoNumbers() {
        XCTAssertEqual(Math.getGCD(0, 5), 5)
        XCTAssertEqual(Math.getGCD(3, 0), 3)
        XCTAssertEqual(Math.getGCD(2, 5), 1)
        XCTAssertEqual(Math.getGCD(4, 8), 4)
        XCTAssertEqual(Math.getGCD(0, 1), 1)
    }
}

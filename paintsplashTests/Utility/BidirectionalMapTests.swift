//
//  BidirectionalMapTests.swift
//  paintsplashTests
//
//  Created by admin on 3/4/21.
//

import XCTest
@testable import paintsplash

class BidirectionalMapTests: XCTestCase {

    func testConstruct() {
        let map = BidirectionalMap<Int, String>()
        XCTAssertEqual(map.count, 0)
        XCTAssertEqual(map.backward, [:])
        XCTAssertEqual(map.forward, [:])
    }

    func testSetting() {
        let map = BidirectionalMap<Int, Int>()
        map.forward = [1: 3, 2: 2, 4: 5]
        XCTAssertEqual(map.count, 3)
        XCTAssertEqual(map.backward, [3: 1, 2: 2, 5: 4])
        XCTAssertEqual(map.forward, [1: 3, 2: 2, 4: 5])

        XCTAssertEqual(map[to: 3], 1)
        XCTAssertEqual(map[from: 4], 5)

        map[to: 4] = 7
        XCTAssertEqual(map[to: 4], 7)
        XCTAssertEqual(map[from: 7], 4)

        map[from: 4] = nil
        map[from: 6] = 5
        XCTAssertEqual(map[to: 5], 6)
        XCTAssertEqual(map[from: 6], 5)
    }
}

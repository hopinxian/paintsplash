//
//  RectTests.swift
//  paintsplashTests
//
//  Created by admin on 3/4/21.
//

import XCTest
@testable import paintsplash

class RectTests: XCTestCase {

    let rect = Rect(minX: -20, maxX: 30, minY: 0, maxY: 10)

    func testContains() {
        XCTAssertTrue(rect.contains(Vector2D(10, 10)))
        XCTAssertTrue(rect.contains(Vector2D(30, 10)))
        XCTAssertTrue(rect.contains(Vector2D(-20, 10)))
        XCTAssertTrue(rect.contains(Vector2D(10, 0)))
        XCTAssertTrue(rect.contains(Vector2D(10, 10)))

        XCTAssertFalse(rect.contains(Vector2D(-21, 10)))
        XCTAssertFalse(rect.contains(Vector2D(31, 10)))
        XCTAssertFalse(rect.contains(Vector2D(-20, -1)))
        XCTAssertFalse(rect.contains(Vector2D(-30, 11)))
        XCTAssertFalse(rect.contains(Vector2D(-21, 11)))
        XCTAssertFalse(rect.contains(Vector2D(31, -1)))
    }

    func testInset() {
        var actual = rect.inset(by: Vector2D(6, 6))
        var expected = Rect(minX: -14, maxX: 24, minY: 6, maxY: 4)

        XCTAssertEqual(actual, expected)

        actual = rect.inset(by: Vector2D(0, 8))
        expected = Rect(minX: -20, maxX: 30, minY: 8, maxY: 2)

        XCTAssertEqual(actual, expected)
    }

    func testClamp() {
        var actual = rect.clamp(point: Vector2D(50, 20))
        var expected = Vector2D(30, 10)
        XCTAssertEqual(actual, expected)

        actual = rect.clamp(point: Vector2D(-50, -20))
        expected = Vector2D(-20, 0)
        XCTAssertEqual(actual, expected)

        actual = rect.clamp(point: Vector2D(0, 0))
        expected = Vector2D(0, 0)
        XCTAssertEqual(actual, expected)
    }
}

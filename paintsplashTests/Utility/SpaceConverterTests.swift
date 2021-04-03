//
//  SpaceConverterTests.swift
//  paintsplashTests
//
//  Created by admin on 3/4/21.
//

import XCTest
@testable import paintsplash

class SpaceConverterTests: XCTestCase {

    override func setUpWithError() throws {
        SpaceConverter.modelSize = Vector2D(150, 100)
        SpaceConverter.screenSize = Vector2D(200, 200)
    }

    func testModelToScreen_cgPoint() {
        var actual: CGPoint = SpaceConverter.modelToScreen(Vector2D(50, 100))
        var expected = CGPoint(x: 100, y: 200)
        XCTAssertEqual(actual, expected)

        actual = SpaceConverter.modelToScreen(Vector2D(80, 40))
        expected = CGPoint(x: 160, y: 80)
        XCTAssertEqual(actual, expected)
    }

    func testModelToScreen_cgSize() {
        var actual: CGSize = SpaceConverter.modelToScreen(Vector2D(50, 100))
        var expected = CGSize(width: 100, height: 200)
        XCTAssertEqual(actual, expected)

        actual = SpaceConverter.modelToScreen(Vector2D(80, 40))
        expected = CGSize(width: 160, height: 80)
        XCTAssertEqual(actual, expected)
    }

    func testModelToScreen_cgFloat() {
        var actual: CGFloat = SpaceConverter.modelToScreen(10.1)
        var expected: CGFloat = 20.2
        XCTAssertEqual(actual, expected)

        actual = SpaceConverter.modelToScreen(20.2)
        expected = 40.4
        XCTAssertEqual(actual, expected)
    }

    func testScreenToModel_cgPoint() {
        var actual = SpaceConverter.screenToModel(CGPoint(x: 100, y: 200))
        var expected = Vector2D(50, 100)
        XCTAssertEqual(actual, expected)

        actual = SpaceConverter.screenToModel(CGPoint(x: 160, y: 80))
        expected = Vector2D(80, 40)
        XCTAssertEqual(actual, expected)
    }

    func testScreenToModel_cgSize() {
        var actual = SpaceConverter.screenToModel(CGSize(width: 100, height: 200))
        var expected = Vector2D(50, 100)
        XCTAssertEqual(actual, expected)

        actual = SpaceConverter.screenToModel(CGSize(width: 160, height: 80))
        expected = Vector2D(80, 40)
        XCTAssertEqual(actual, expected)
    }

    func testScreenToModel_cgFloat() {
        var actual = SpaceConverter.screenToModel(20.2)
        var expected = 10.1
        XCTAssertEqual(actual, expected)

        actual = SpaceConverter.screenToModel(40.4)
        expected = 20.2
        XCTAssertEqual(actual, expected)
    }
}

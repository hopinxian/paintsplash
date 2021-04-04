//
//  FirebasePathsTests.swift
//  paintsplashTests
//
//  Created by Praveen Bala on 3/4/21.
//

import XCTest
@testable import paintsplash

class FirebasePathsTests: XCTestCase {

    func testJoinPaths() {
        let expected = "First/Second"
        let result = DataPaths.joinPaths("First", "Second")
        XCTAssertEqual(expected, result)
    }

    func testJoinPathsFirtPathEmptyString() {
        let expected = "/Second"
        let result = DataPaths.joinPaths("", "Second")
        XCTAssertEqual(expected, result)
    }

    func testJoinPathsSecondPathEmptyString() {
        let expected = "First/"
        let result = DataPaths.joinPaths("First", "")
        XCTAssertEqual(expected, result)
    }

    func testJoinPathsBothPathsEmptyString() {
        let expected = "/"
        let result = DataPaths.joinPaths("", "")
        XCTAssertEqual(expected, result)
    }

    func testJoinPathsNonAscii() {
        let expected = "😊/👍"
        let result = DataPaths.joinPaths("😊", "👍")
        XCTAssertEqual(expected, result)
    }
}

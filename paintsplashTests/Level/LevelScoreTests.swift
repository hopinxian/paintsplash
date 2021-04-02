//
//  LevelScoreTests.swift
//  paintsplashTests
//
//  Created by Ho Pin Xian on 21/3/21.
//

import XCTest
@testable import paintsplash

class LevelScoreTests: XCTestCase {
    
    func testConstruct() {
        let score = LevelScore()

        XCTAssertTrue(score.freeze)
        XCTAssertEqual(score.score, 0)
        XCTAssertEqual(score.renderComponent.zPosition, Constants.ZPOSITION_UI_ELEMENT)
    }

    func testReset() {
        let score = LevelScore()
        score.score = 200
        score.reset()

        XCTAssertEqual(score.score, 0)
    }

    func testOnScoreEvent() {
        let event = ScoreEvent(value: 100)
        let score = LevelScore()

        score.onScoreEvent(event: event)
        XCTAssertEqual(score.score, 0)

        score.freeze = false
        score.onScoreEvent(event: event)
        XCTAssertEqual(score.score, 100)

        score.onScoreEvent(event: event)
        XCTAssertEqual(score.score, 200)
    }
}

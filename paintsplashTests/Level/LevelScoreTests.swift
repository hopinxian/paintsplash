//
//  LevelScoreTests.swift
//  paintsplashTests
//
//  Created by Ho Pin Xian on 21/3/21.
//

import XCTest
@testable import paintsplash

class LevelScoreTests: XCTestCase {

    let gameManager = GameManager(renderSystem: MockRenderSystem(), collisionSystem: MockCollisionSystem())

    func testConstruct() {
        let score = LevelScore(gameManager: gameManager)

        XCTAssertTrue(score.freeze)
        XCTAssertEqual(score.score, 0)
        XCTAssertEqual(score.transform, Transform(position: Vector2D(-300, -495), rotation: 0, size: Vector2D(90, 50)))
        XCTAssertEqual(score.zPosition, Constants.ZPOSITION_UI_ELEMENT)
    }

    func testReset() {
        let score = LevelScore(gameManager: gameManager)
        score.score = 200
        score.reset()

        XCTAssertEqual(score.score, 0)
    }

    func testOnScoreEvent() {
        let event = ScoreEvent(value: 100)
        let score = LevelScore(gameManager: gameManager)

        score.onScoreEvent(event: event)
        XCTAssertEqual(score.score, 0)

        score.freeze = false
        score.onScoreEvent(event: event)
        XCTAssertEqual(score.score, 100)

        score.onScoreEvent(event: event)
        XCTAssertEqual(score.score, 200)
    }
}

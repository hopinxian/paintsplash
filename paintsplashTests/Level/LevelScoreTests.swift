//
//  LevelScoreTests.swift
//  paintsplashTests
//
//  Created by Ho Pin Xian on 21/3/21.
//

import XCTest
@testable import paintsplash

class LevelScoreTests: XCTestCase {

    var gameManager: GameManager!
    
    override func setUp() {
        super.setUp()
        let gameManager = SinglePlayerGameManager(gameScene: GameScene())
        gameManager.renderSystem = MockRenderSystem()
        gameManager.collisionSystem = MockCollisionSystem()
        self.gameManager = gameManager
    }
    
    func testConstruct() {
        let score = LevelScore(gameManager: gameManager)

        XCTAssertTrue(score.freeze)
        XCTAssertEqual(score.score, 0)
        XCTAssertEqual(score.renderComponent.zPosition, Constants.ZPOSITION_UI_ELEMENT)
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

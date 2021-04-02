//
//  EnemyRenderableTests.swift
//  paintsplashTests
//
//  Created by Farrell Nah on 21/3/21.
//

import Foundation

import XCTest
@testable import paintsplash

class EnemyRenderableTests: XCTestCase {

    var enemy: Enemy!
    var gameManager: GameManager!
    var mockRenderSystem: MockRenderSystem!

    override func setUp() {
        super.setUp()
        enemy = Enemy(initialPosition: Vector2D.zero, color: .red)
        mockRenderSystem = MockRenderSystem()
        let gameScene = GameScene()
        let gameManager = SinglePlayerGameManager(gameScene: gameScene)
        gameManager.renderSystem = mockRenderSystem
        gameManager.collisionSystem = MockCollisionSystem()
        self.gameManager = gameManager
    }

    func testSpawn_addsRenderable() {
        enemy.spawn()
        XCTAssertTrue(mockRenderSystem.activeRenderables.contains(where: { $0 === enemy }))
    }

    func testUpdate_updatesRenderable() {
        enemy.spawn()
        enemy.moveableComponent.direction = Vector2D.right
        enemy.moveableComponent.speed = 1
        let oldPosition = enemy.transformComponent.worldPosition
        FrameMovementSystem().updateEntity(enemy, enemy)
        guard let updatedPlayer = mockRenderSystem.updatedRenderables.first(where: { $0 === enemy }) else {
            XCTFail("Enemy was not updated")
            return
        }
        let expectedPosition = oldPosition + Vector2D(1, 0)
        XCTAssertEqual(updatedPlayer.transformComponent.worldPosition, expectedPosition)

    }

    func testDestroy_removesRenderable() {
        enemy.spawn()
        enemy.destroy()
        XCTAssertNil(mockRenderSystem.updatedRenderables.first(where: { $0 === enemy }))
    }
}

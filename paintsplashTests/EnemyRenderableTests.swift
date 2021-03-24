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
        enemy = Enemy(initialPosition: Vector2D.zero, initialVelocity: Vector2D.zero, color: .red)
        mockRenderSystem = MockRenderSystem()
        gameManager = GameManager(renderSystem: mockRenderSystem, collisionSystem: MockCollisionSystem())
    }

    func testSpawn_addsRenderable() {
        enemy.spawn(gameManager: gameManager)
        XCTAssertTrue(mockRenderSystem.activeRenderables.contains(where: { $0 === enemy }))
    }

    func testUpdate_updatesRenderable() {
        enemy.spawn(gameManager: gameManager)
        enemy.velocity = Vector2D(1, 0)
        let oldPosition = enemy.transform.position
        enemy.move()
        enemy.update(gameManager: gameManager)
        guard let updatedPlayer = mockRenderSystem.updatedRenderables.first(where: { $0 === enemy }) else {
            XCTFail("Enemy was not updated")
            return
        }
        let expectedPosition = oldPosition + Vector2D(1, 0)
        XCTAssertEqual(updatedPlayer.transform.position, expectedPosition)

    }

    func testDestroy_removesRenderable() {
        enemy.spawn(gameManager: gameManager)
        enemy.destroy(gameManager: gameManager)
        XCTAssertNil(mockRenderSystem.updatedRenderables.first(where: { $0 === enemy }))
    }
}

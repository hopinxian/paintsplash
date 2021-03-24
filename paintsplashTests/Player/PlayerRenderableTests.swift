//
//  PlayerSpawnTests.swift
//  paintsplashTests
//
//  Created by Farrell Nah on 21/3/21.
//

import XCTest
@testable import paintsplash

class PlayerRenderableTests: XCTestCase {

    var player: Player!
    var gameManager: GameManager!
    var mockRenderSystem: MockRenderSystem!

    override func setUp() {
        super.setUp()
        player = Player(initialPosition: Vector2D.zero, initialVelocity: Vector2D.zero)
        mockRenderSystem = MockRenderSystem()
        gameManager = GameManager(renderSystem: mockRenderSystem, collisionSystem: MockCollisionSystem())
    }

    func testSpawn_addsRenderable() {
        player.spawn(gameManager: gameManager)
        XCTAssertTrue(mockRenderSystem.activeRenderables.contains(where: { $0 === player }))
    }

    func testUpdate_updatesRenderable() {
        player.spawn(gameManager: gameManager)
        player.velocity = Vector2D(1, 0)
        let oldPosition = player.transform.position
        player.update(gameManager: gameManager)
        guard let updatedPlayer = mockRenderSystem.updatedRenderables.first(where: { $0 === player }) else {
            XCTFail("Player was not updated")
            return
        }
        let expectedPosition = oldPosition + Vector2D(1, 0)
        XCTAssertEqual(updatedPlayer.transform.position, expectedPosition)

    }

    func testDestroy_removesRenderable() {
        player.spawn(gameManager: gameManager)
        player.destroy(gameManager: gameManager)
        XCTAssertNil(mockRenderSystem.updatedRenderables.first(where: { $0 === player }))
    }
}

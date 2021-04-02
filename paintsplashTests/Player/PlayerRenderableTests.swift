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
        player = Player(initialPosition: Vector2D.zero)
        mockRenderSystem = MockRenderSystem()
        let gameScene = GameScene()
        let gameManager = SinglePlayerGameManager(gameScene: gameScene)
        gameManager.renderSystem = mockRenderSystem
        gameManager.collisionSystem = MockCollisionSystem()
        self.gameManager = gameManager
    }

    func testSpawn_addsRenderable() {
        player.spawn()
        XCTAssertTrue(mockRenderSystem.activeRenderables.contains(where: { $0 === player }))
    }

    func testUpdate_updatesRenderable() {
        player.spawn()
        player.moveableComponent.direction = Vector2D(1, 0)
        let oldPosition = player.transformComponent.worldPosition
        player.update()
        guard let updatedPlayer = mockRenderSystem.updatedRenderables.first(where: { $0 === player }) else {
            XCTFail("Player was not updated")
            return
        }
        let expectedPosition = oldPosition + Vector2D(1, 0)
        XCTAssertEqual(updatedPlayer.transformComponent.worldPosition, expectedPosition)

    }

    func testDestroy_removesRenderable() {
        player.spawn()
        player.destroy()
        XCTAssertNil(mockRenderSystem.updatedRenderables.first(where: { $0 === player }))
    }
}

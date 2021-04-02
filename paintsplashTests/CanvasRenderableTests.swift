//
//  CanvasRenderable.swift
//  paintsplashTests
//
//  Created by Farrell Nah on 21/3/21.
//

import XCTest
@testable import paintsplash

class CanvasRenderableTests: XCTestCase {

    var canvas: Canvas!
    var gameManager: GameManager!
    var mockRenderSystem: MockRenderSystem!

    override func setUp() {
        super.setUp()
        canvas = Canvas(initialPosition: Vector2D.zero, direction: Vector2D.zero, size: Vector2D.zero, endX: 0.0)
        mockRenderSystem = MockRenderSystem()
        let gameScene = GameScene()
        let gameManager = SinglePlayerGameManager(gameScene: gameScene)
        gameManager.renderSystem = mockRenderSystem
        gameManager.collisionSystem = MockCollisionSystem()
        self.gameManager = gameManager
    }

    func testSpawn_addsRenderable() {
        canvas.spawn()
        XCTAssertTrue(mockRenderSystem.activeRenderables.contains(where: { $0 === canvas }))
    }

    func testUpdate_updatesRenderable() {
        canvas.spawn()
        canvas.moveableComponent.direction = Vector2D.right
        canvas.moveableComponent.speed = 1
        let oldPosition = canvas.transformComponent.worldPosition
        FrameMovementSystem().updateEntity(canvas, canvas)
        guard let updatedPlayer = mockRenderSystem.updatedRenderables.first(where: { $0 === canvas }) else {
            XCTFail("Canvas was not updated")
            return
        }
        let expectedPosition = oldPosition + Vector2D.right
        XCTAssertEqual(updatedPlayer.transformComponent.worldPosition, expectedPosition)

    }

    func testDestroy_removesRenderable() {
        canvas.spawn()
        canvas.destroy()
        XCTAssertNil(mockRenderSystem.updatedRenderables.first(where: { $0 === canvas }))
    }
}

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
        canvas = Canvas(initialPosition: Vector2D.zero, velocity: Vector2D.zero, size: Vector2D.zero, endX: 0.0)
        mockRenderSystem = MockRenderSystem()
        gameManager = GameManager(renderSystem: mockRenderSystem, collisionSystem: MockCollisionSystem())
    }

    func testSpawn_addsRenderable() {
        canvas.spawn(gameManager: gameManager)
        XCTAssertTrue(mockRenderSystem.activeRenderables.contains(where: { $0 === canvas }))
    }

    func testUpdate_updatesRenderable() {
        canvas.spawn(gameManager: gameManager)
        canvas.velocity = Vector2D(1, 0)
        let oldPosition = canvas.transform.position
        canvas.move()
        canvas.update(gameManager: gameManager)
        guard let updatedPlayer = mockRenderSystem.updatedRenderables.first(where: { $0 === canvas }) else {
            XCTFail("Canvas was not updated")
            return
        }
        let expectedPosition = oldPosition + Vector2D(1, 0)
        XCTAssertEqual(updatedPlayer.transform.position, expectedPosition)

    }

    func testDestroy_removesRenderable() {
        canvas.spawn(gameManager: gameManager)
        canvas.destroy(gameManager: gameManager)
        XCTAssertNil(mockRenderSystem.updatedRenderables.first(where: { $0 === canvas }))
    }
}

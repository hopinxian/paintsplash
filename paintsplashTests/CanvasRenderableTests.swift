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
        let gameManager = MockGameManager()
        gameManager.renderSystem = mockRenderSystem
        self.gameManager = gameManager
    }

    func testSpawn_addsRenderable() {
        canvas.spawn()
        XCTAssertTrue(mockRenderSystem.activeRenderables.contains(where: { $0 === canvas }))
    }

    func testDestroy_removesRenderable() {
        canvas.spawn()
        canvas.destroy()
        XCTAssertNil(mockRenderSystem.updatedRenderables.first(where: { $0 === canvas }))
    }
}

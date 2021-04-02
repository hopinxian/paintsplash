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
        let gameManager = MockGameManager()
        gameManager.renderSystem = mockRenderSystem
        self.gameManager = gameManager
    }

    func testSpawn_addsRenderable() {
        player.spawn()
        XCTAssertTrue(mockRenderSystem.activeRenderables.contains(where: { $0 === player }))
    }

    func testDestroy_removesRenderable() {
        player.spawn()
        player.destroy()
        XCTAssertNil(mockRenderSystem.updatedRenderables.first(where: { $0 === player }))
    }
}

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
        let gameManager = MockGameManager()
        gameManager.renderSystem = mockRenderSystem
        self.gameManager = gameManager
    }

    func testSpawn_addsRenderable() {
        enemy.spawn()
        XCTAssertTrue(mockRenderSystem.activeRenderables.contains(where: { $0 === enemy }))
    }

    func testDestroy_removesRenderable() {
        enemy.spawn()
        enemy.destroy()
        XCTAssertNil(mockRenderSystem.updatedRenderables.first(where: { $0 === enemy }))
    }
}

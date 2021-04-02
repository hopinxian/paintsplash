//
//  PlayerMovementBoundsTests.swift
//  paintsplashTests
//
//  Created by Praveen Bala on 21/3/21.
//

import XCTest
@testable import paintsplash

class PlayerMovementBoundsTests: XCTestCase {

    private let boundSize: Double = 500

    private var player: Player!

    private var bounds: Rect {
        Rect(minX: -boundSize, maxX: boundSize, minY: -boundSize, maxY: boundSize)
    }

    private var leftBound: Vector2D {
       (Vector2D.left * boundSize) + Vector2D(playerWidth / 2, 0)
    }

    private var rightBound: Vector2D {
        (Vector2D.right * boundSize) - Vector2D(playerWidth / 2, 0)
    }

    private var topBound: Vector2D {
        (Vector2D.up * boundSize) - Vector2D(0, playerHeight / 2)
    }

    private var bottomBound: Vector2D {
        (Vector2D.down * boundSize) + Vector2D(0, playerHeight / 2)
    }

    private var playerWidth = 128
    private var playerHeight = 128

    override func setUp() {
        super.setUp()
        player = Player(initialPosition: Vector2D.zero)
    }

    func testPlayerHorizontalMovementWithinBounds() {
        // Move left
        XCTAssertEqual(player.transformComponent.worldPosition, Vector2D.zero)
        player.moveableComponent.direction = Vector2D.left
        FrameMovementSystem().updateEntity(player, player)
        XCTAssertEqual(player.transformComponent.worldPosition, Vector2D.left)

        // Move right
        player.moveableComponent.direction = Vector2D.right
        FrameMovementSystem().updateEntity(player, player)
        XCTAssertEqual(player.transformComponent.worldPosition, Vector2D.zero)
    }

    func testPlayerVerticalMovementWithinBounds() {
        // Move up
        XCTAssertEqual(player.transformComponent.worldPosition, Vector2D.zero)
        player.moveableComponent.direction = Vector2D.up
        FrameMovementSystem().updateEntity(player, player)
        XCTAssertEqual(player.transformComponent.worldPosition, Vector2D.up)
        
        // Move down
        player.moveableComponent.direction = Vector2D.down
        FrameMovementSystem().updateEntity(player, player)
        XCTAssertEqual(player.transformComponent.worldPosition, Vector2D.zero)
    }

    func testPlayerHorizontalMovementToBoundaryLimit() {
        XCTAssertEqual(player.transformComponent.worldPosition, Vector2D.zero)

        // Move left
        player.moveableComponent.direction = Vector2D.left
        player.moveableComponent.speed = leftBound.magnitude
        FrameMovementSystem().updateEntity(player, player)
        XCTAssertEqual(player.transformComponent.worldPosition, leftBound)

        // Move past left bound
        FrameMovementSystem().updateEntity(player, player)
        XCTAssertEqual(player.transformComponent.worldPosition, leftBound)
        
        // Move right (back to zero)
        player.moveableComponent.direction = Vector2D.right
        FrameMovementSystem().updateEntity(player, player)
        XCTAssertEqual(player.transformComponent.worldPosition, .zero)
        
        // Move right (to right bound)
        player.moveableComponent.direction = Vector2D.right
        player.moveableComponent.speed = rightBound.magnitude
        FrameMovementSystem().updateEntity(player, player)
        XCTAssertEqual(player.transformComponent.worldPosition, rightBound)
        
        // Move past right bound
        FrameMovementSystem().updateEntity(player, player)
        XCTAssertEqual(player.transformComponent.worldPosition, rightBound)
    }

    func testPlayerVerticalMovementToBoundaryLimit() {
        XCTAssertEqual(player.transformComponent.worldPosition, Vector2D.zero)

        // Move up
        player.moveableComponent.direction = Vector2D.up
        player.moveableComponent.speed = topBound.magnitude
        FrameMovementSystem().updateEntity(player, player)
        XCTAssertEqual(player.transformComponent.worldPosition, topBound)
        
        // Move past top bound
        FrameMovementSystem().updateEntity(player, player)
        XCTAssertEqual(player.transformComponent.worldPosition, topBound)
        
        // Move down (back to zero)
        player.moveableComponent.direction = Vector2D.down
        FrameMovementSystem().updateEntity(player, player)
        XCTAssertEqual(player.transformComponent.worldPosition, .zero)
        
        // Move down (to bottm bound)
        FrameMovementSystem().updateEntity(player, player)
        XCTAssertEqual(player.transformComponent.worldPosition, bottomBound)

        // Move past bottom bound
        FrameMovementSystem().updateEntity(player, player)
        XCTAssertEqual(player.transformComponent.worldPosition, bottomBound)
    }
}

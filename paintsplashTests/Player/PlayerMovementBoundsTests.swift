//
//  PlayerMovementBoundsTests.swift
//  paintsplashTests
//
//  Created by Praveen Bala on 21/3/21.
//

import XCTest
@testable import paintsplash

class PlayerMovementBoundsTests: XCTestCase {

    private var player: Player!

    private var bounds = Constants.PLAYER_MOVEMENT_BOUNDS

    private var leftBound: Vector2D {
        (Vector2D.left * abs(bounds.minX)) + Vector2D(playerWidth / 2, 0)
    }

    private var rightBound: Vector2D {
        (Vector2D.right * bounds.maxX) - Vector2D(playerWidth / 2, 0)
    }

    private var topBound: Vector2D {
        (Vector2D.up * bounds.maxY) - Vector2D(0, playerHeight / 2)
    }

    private var bottomBound: Vector2D {
        (Vector2D.down * abs(bounds.minY)) + Vector2D(0, playerHeight / 2)
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
        player.moveableComponent.speed = 1
        FrameMovementSystem().updateEntity(player, player, 1)
        XCTAssertEqual(player.transformComponent.localPosition, Vector2D.left)

        // Move right
        player.moveableComponent.direction = Vector2D.right
        FrameMovementSystem().updateEntity(player, player, 1)
        XCTAssertEqual(player.transformComponent.worldPosition, Vector2D.zero)
    }

    func testPlayerVerticalMovementWithinBounds() {
        // Move up
        XCTAssertEqual(player.transformComponent.worldPosition, Vector2D.zero)
        player.moveableComponent.direction = Vector2D.up
        player.moveableComponent.speed = 1
        FrameMovementSystem().updateEntity(player, player, 1)
        XCTAssertEqual(player.transformComponent.localPosition, Vector2D.up)

        // Move down
        player.moveableComponent.direction = Vector2D.down
        FrameMovementSystem().updateEntity(player, player, 1)
        XCTAssertEqual(player.transformComponent.worldPosition, Vector2D.zero)
    }

    func testPlayerHorizontalMovementToBoundaryLimit() {
        XCTAssertEqual(player.transformComponent.worldPosition, Vector2D.zero)

        // Move left
        player.moveableComponent.direction = Vector2D.left
        player.moveableComponent.speed = leftBound.magnitude
        FrameMovementSystem().updateEntity(player, player, 1)
        XCTAssertEqual(player.transformComponent.localPosition, leftBound)

        // Move past left bound
        FrameMovementSystem().updateEntity(player, player, 1)
        XCTAssertEqual(player.transformComponent.localPosition, leftBound)

        // Move right (back to zero)
        player.moveableComponent.direction = Vector2D.right
        FrameMovementSystem().updateEntity(player, player, 1)
        XCTAssertEqual(player.transformComponent.worldPosition, .zero)

        // Move right (to right bound)
        player.moveableComponent.direction = Vector2D.right
        player.moveableComponent.speed = rightBound.magnitude
        FrameMovementSystem().updateEntity(player, player, 1)
        XCTAssertEqual(player.transformComponent.localPosition, rightBound)

        // Move past right bound
        FrameMovementSystem().updateEntity(player, player, 1)
        XCTAssertEqual(player.transformComponent.localPosition, rightBound)
    }

    func testPlayerVerticalMovementToBoundaryLimit() {
        XCTAssertEqual(player.transformComponent.worldPosition, Vector2D.zero)

        // Move up
        player.moveableComponent.direction = Vector2D.up
        player.moveableComponent.speed = topBound.magnitude
        FrameMovementSystem().updateEntity(player, player, 1)
        XCTAssertEqual(player.transformComponent.localPosition, topBound)

        // Move past top bound
        FrameMovementSystem().updateEntity(player, player, 1)
        XCTAssertEqual(player.transformComponent.localPosition, topBound)

        // Move down (back to zero)
        player.moveableComponent.direction = Vector2D.down
        FrameMovementSystem().updateEntity(player, player, 1)
        XCTAssertEqual(player.transformComponent.localPosition, .zero)

        // Move down (to bottom bound)
        player.moveableComponent.speed = bottomBound.magnitude
        FrameMovementSystem().updateEntity(player, player, 1)
        XCTAssertEqual(player.transformComponent.localPosition, bottomBound)

        // Move past bottom bound
        FrameMovementSystem().updateEntity(player, player, 1)
        XCTAssertEqual(player.transformComponent.localPosition, bottomBound)
    }
}

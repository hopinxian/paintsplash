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

    private var playerWidth = Transform.standard.size.x
    private var playerHeight = Transform.standard.size.y

    override func setUp() {
        super.setUp()
        player = Player(initialPosition: Vector2D.zero, initialVelocity: Vector2D.zero)
        player.movementBounds = bounds
    }

    func testPlayerHorizontalMovementWithinBounds() {
        // Move left
        XCTAssertEqual(player.position, Vector2D.zero)
        player.velocity = Vector2D.left
        player.move()
        XCTAssertEqual(player.position, Vector2D.left)

        // Move right
        player.velocity = Vector2D.right
        player.move()
        XCTAssertEqual(player.position, Vector2D.zero)
    }

    func testPlayerVerticalMovementWithinBounds() {
        // Move up
        XCTAssertEqual(player.position, Vector2D.zero)
        player.velocity = Vector2D.up
        player.move()
        XCTAssertEqual(player.position, Vector2D.up)

        // Move down
        player.velocity = Vector2D.down
        player.move()
        XCTAssertEqual(player.position, Vector2D.zero)
    }

    func testPlayerHorizontalMovementToBoundaryLimit() {
        XCTAssertEqual(player.position, Vector2D.zero)

        // Move left
        player.velocity = leftBound
        player.move()
        player.clampPosition()
        XCTAssertEqual(player.position, leftBound)

        // Move past left bound
        player.velocity = Vector2D.left
        player.move()
        player.clampPosition()
        XCTAssertEqual(player.position, leftBound)

        // Move right (back to zero)
        player.velocity = leftBound * -1
        player.move()
        player.clampPosition()
        XCTAssertEqual(player.position, Vector2D.zero)

        // Move right (to right bound)
        player.velocity = rightBound
        player.move()
        player.clampPosition()
        XCTAssertEqual(player.position, rightBound)

        // Move past right bound
        player.velocity = Vector2D.right
        player.move()
        player.clampPosition()
        XCTAssertEqual(player.position, rightBound)
    }

    func testPlayerVerticalMovementToBoundaryLimit() {
        XCTAssertEqual(player.position, Vector2D.zero)

        // Move up
        player.velocity = topBound
        player.move()
        player.clampPosition()
        XCTAssertEqual(player.position, topBound)

        // Move past top bound
        player.velocity = Vector2D.up
        player.move()
        player.clampPosition()
        XCTAssertEqual(player.position, topBound)

        // Move down (back to zero)
        player.velocity = topBound * -1
        player.move()
        player.clampPosition()
        XCTAssertEqual(player.position, Vector2D.zero)

        // Move down (to bottm bound)
        player.velocity = bottomBound
        player.move()
        player.clampPosition()
        XCTAssertEqual(player.position, bottomBound)

        // Move past bottom bound
        player.velocity = Vector2D.down
        player.move()
        player.clampPosition()
        XCTAssertEqual(player.position, bottomBound)
    }
}

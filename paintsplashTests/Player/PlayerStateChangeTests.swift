//
//  PlayerStateChangeTests.swift
//  paintsplashTests
//
//  Created by Praveen Bala on 21/3/21.
//

import XCTest
@testable import paintsplash

class PlayerStateChangeTests: XCTestCase {

    private var player: Player!
    private var playerInitialState: PlayerState!

    override func setUp() {
        super.setUp()
        player = Player(initialPosition: Vector2D.zero, initialVelocity: Vector2D.zero)
        playerInitialState = player.state
    }

    func testPlayerStateChanges() {
        XCTAssertEqual(player.state, playerInitialState)

        // move left
        player.velocity = Vector2D.left
        XCTAssertEqual(player.lastDirection, Vector2D.left)
        player.setState()
        XCTAssertEqual(player.state, .moveLeft)

        // stop moving left
        player.velocity = Vector2D.zero
        player.setState()
        XCTAssertEqual(player.lastDirection, Vector2D.left)
        XCTAssertEqual(player.state, .idleLeft)

        // move right
        player.velocity = Vector2D.right
        XCTAssertEqual(player.lastDirection, Vector2D.right)
        player.setState()
        XCTAssertEqual(player.state, .moveRight)

        // stop moving left
        player.velocity = Vector2D.zero
        player.setState()
        XCTAssertEqual(player.lastDirection, Vector2D.right)
        XCTAssertEqual(player.state, .idleRight)

        // move up
        player.velocity = Vector2D.up
        player.setState()
        XCTAssertEqual(player.lastDirection, Vector2D.up)
        XCTAssertEqual(player.state, .moveRight) // Player still facing right (last position)

        // stop moving up
        player.velocity = Vector2D.zero
        player.setState()
        XCTAssertEqual(player.lastDirection, Vector2D.up)
        XCTAssertEqual(player.state, .idleRight) // Player still facing right (last position)
    }

}

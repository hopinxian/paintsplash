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
        player = Player(initialPosition: Vector2D.zero)
        playerInitialState = player.stateComponent.currentState as? PlayerState
    }

    func testPlayerStateChanges() {
        let manager = GameStateManagerSystem(gameInfo: GameInfo(playerPosition: Vector2D.zero, numberOfEnemies: 0))

        // move left
        var event = PlayerMoveEvent(direction: Vector2D.left, playerID: player.id)
        player.playableComponent.onMove(event: event)
        XCTAssertEqual(player.lastDirection, Vector2D.left)
        manager.updateEntity(player, player)
        XCTAssertTrue(player.stateComponent.currentState is PlayerState.MoveLeft)

        // stop moving left
        event = PlayerMoveEvent(direction: Vector2D.zero, playerID: player.id)
        player.playableComponent.onMove(event: event)
        XCTAssertEqual(player.lastDirection, Vector2D.left)
        manager.updateEntity(player, player)
        XCTAssertTrue(player.stateComponent.currentState is PlayerState.IdleLeft)

        // move right
        event = PlayerMoveEvent(direction: Vector2D.right, playerID: player.id)
        player.playableComponent.onMove(event: event)
        XCTAssertEqual(player.lastDirection, Vector2D.right)
        manager.updateEntity(player, player)
        XCTAssertTrue(player.stateComponent.currentState is PlayerState.MoveRight)

        // stop moving right
        event = PlayerMoveEvent(direction: Vector2D.zero, playerID: player.id)
        player.playableComponent.onMove(event: event)
        XCTAssertEqual(player.lastDirection, Vector2D.right)
        manager.updateEntity(player, player)
        XCTAssertTrue(player.stateComponent.currentState is PlayerState.IdleRight)

        // move up
        event = PlayerMoveEvent(direction: Vector2D.up, playerID: player.id)
        player.playableComponent.onMove(event: event)
        XCTAssertEqual(player.lastDirection, Vector2D.up)
        manager.updateEntity(player, player)
        XCTAssertTrue(player.stateComponent.currentState is PlayerState.IdleRight)
        // Player still facing right (last position)

        // stop moving up
        event = PlayerMoveEvent(direction: Vector2D.zero, playerID: player.id)
        player.playableComponent.onMove(event: event)
        XCTAssertEqual(player.lastDirection, Vector2D.up)
        manager.updateEntity(player, player)
        XCTAssertTrue(player.stateComponent.currentState
                        is PlayerState.IdleRight) // Player still facing right (last position)
    }

}

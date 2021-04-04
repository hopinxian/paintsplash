//
//  PlayerHealthTests.swift
//  paintsplashTests
//
//  Created by Praveen Bala on 21/3/21.
//

import XCTest
@testable import paintsplash

class PlayerHealthTests: XCTestCase {

    var player: Player!

    override func setUp() {
        super.setUp()
        player = Player(initialPosition: Vector2D.zero)
    }

    func testPlayerDamage() {
        XCTAssertEqual(player.healthComponent.currentHealth, player.healthComponent.maxHealth)

        for index in 1..<player.healthComponent.maxHealth {
            player.healthComponent.takeDamage(amount: 1)
            XCTAssertEqual(player.healthComponent.currentHealth, player.healthComponent.maxHealth - index)
        }
    }

    func testPlayerDeathWhenHealthZero() {
        XCTAssertEqual(player.healthComponent.currentHealth, player.healthComponent.maxHealth)

        player.healthComponent.takeDamage(amount: player.healthComponent.maxHealth)
        XCTAssertTrue(player.stateComponent.currentState is PlayerState.Die)
        XCTAssertEqual(player.healthComponent.currentHealth, 0)
    }

    func testPlayerDeathWhenHealthLessThanZero() {
        XCTAssertEqual(player.healthComponent.currentHealth, player.healthComponent.maxHealth)

        player.healthComponent.takeDamage(amount: player.healthComponent.maxHealth + 1)
        XCTAssertTrue(player.stateComponent.currentState is PlayerState.Die)
        XCTAssertEqual(player.healthComponent.currentHealth, 0)
    }

    func testPlayerHeal() {
        player.healthComponent.takeDamage(amount: player.healthComponent.maxHealth - 1)
        XCTAssertEqual(player.healthComponent.currentHealth, 1)

        player.healthComponent.heal(amount: 1)
        XCTAssertEqual(player.healthComponent.currentHealth, 2)

        player.healthComponent.heal(amount: player.healthComponent.maxHealth - 2)
        XCTAssertEqual(player.healthComponent.currentHealth, player.healthComponent.maxHealth)
    }

    func testPlayerHealPastMaxHealth() {
        player.healthComponent.takeDamage(amount: 1)
        XCTAssertEqual(player.healthComponent.currentHealth, player.healthComponent.maxHealth - 1)

        player.healthComponent.heal(amount: player.healthComponent.maxHealth)
        XCTAssertEqual(player.healthComponent.currentHealth, player.healthComponent.maxHealth)
    }

}

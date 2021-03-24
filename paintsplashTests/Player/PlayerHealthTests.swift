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
        player = Player(initialPosition: Vector2D.zero, initialVelocity: Vector2D.zero)
    }

    func testPlayerDamage() {
        XCTAssertEqual(player.currentHealth, player.maxHealth)

        for index in 1..<player.maxHealth {
            player.takeDamage(amount: 1)
            XCTAssertEqual(player.currentHealth, player.maxHealth - i)
        }
    }

    func testPlayerDeathWhenHealthZero() {
        XCTAssertEqual(player.currentHealth, player.maxHealth)

        player.takeDamage(amount: player.maxHealth)
        XCTAssertEqual(player.state, .die)
        XCTAssertEqual(player.currentHealth, 0)
    }

    func testPlayerDeathWhenHealthLessThanZero() {
        XCTAssertEqual(player.currentHealth, player.maxHealth)

        player.takeDamage(amount: player.maxHealth + 1)
        XCTAssertEqual(player.state, .die)
        XCTAssertEqual(player.currentHealth, 0)
    }

    func testPlayerHeal() {
        player.takeDamage(amount: player.maxHealth - 1)
        XCTAssertEqual(player.currentHealth, 1)

        player.heal(amount: 1)
        XCTAssertEqual(player.currentHealth, 2)

        player.heal(amount: player.maxHealth - 2)
        XCTAssertEqual(player.currentHealth, player.maxHealth)
    }

    func testPlayerHealPastMaxHealth() {
        player.takeDamage(amount: 1)
        XCTAssertEqual(player.currentHealth, player.maxHealth - 1)

        player.heal(amount: player.maxHealth)
        XCTAssertEqual(player.currentHealth, player.maxHealth)
    }

}

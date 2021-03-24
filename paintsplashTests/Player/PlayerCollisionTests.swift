//
//  PlayerCollisionTests.swift
//  paintsplashTests
//
//  Created by Praveen Bala on 21/3/21.
//

import XCTest
@testable import paintsplash

class PlayerCollisionTests: XCTestCase {

    var player: Player!

    override func setUp() {
        super.setUp()
        player = Player(initialPosition: Vector2D.zero, initialVelocity: Vector2D.zero)
    }

    func testCollideWithEnemyLoseHealth() {
        XCTAssertEqual(player.currentHealth, player.maxHealth)

        let enemy = Enemy(initialPosition: Vector2D.zero, initialVelocity: Vector2D.zero, color: .blue)
        player.onCollide(otherObject: enemy)

        XCTAssertEqual(player.currentHealth, player.maxHealth - 1)
    }

    func testCollideWithEnemySpawnerNoChangeInHealth() {
        XCTAssertEqual(player.currentHealth, player.maxHealth)

        let enemy = EnemySpawner(initialPosition: Vector2D.zero, initialVelocity: Vector2D.zero, color: .blue)
        player.onCollide(otherObject: enemy)

        XCTAssertEqual(player.currentHealth, player.maxHealth)
    }

    func testCollideWithAmmoDrop() {
        let weaponSystem = player.paintWeaponsSystem

        while weaponSystem.shoot(in: Vector2D.zero) { } // shoot until weapon has no ammo left

        let ammo = PaintAmmoDrop(color: .blue, position: Vector2D.zero)
        let canLoad = weaponSystem.canLoad([ammo.getAmmoObject()])
        XCTAssertTrue(canLoad) // weapon can be loaded

        player.onCollide(otherObject: ammo) // weapon should load
        XCTAssertTrue(weaponSystem.shoot(in: Vector2D.zero)) // weapon should be able to fire
    }

}

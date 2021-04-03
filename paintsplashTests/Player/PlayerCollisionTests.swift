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
        player = Player(initialPosition: Vector2D.zero)
    }

    func testCollideWithEnemyLoseHealth() {
        XCTAssertEqual(player.healthComponent.currentHealth, player.healthComponent.maxHealth)

        let enemy = Enemy(initialPosition: Vector2D.zero, color: .blue)
        player.onCollide(with: enemy)

        XCTAssertEqual(player.healthComponent.currentHealth, player.healthComponent.maxHealth - 1)
    }

    func testCollideWithEnemySpawnerNoChangeInHealth() {
        XCTAssertEqual(player.healthComponent.currentHealth, player.healthComponent.maxHealth)

        let enemy = EnemySpawner(initialPosition: Vector2D.zero, color: .blue)
        player.onCollide(with: enemy)

        XCTAssertEqual(player.healthComponent.currentHealth, player.healthComponent.maxHealth)
    }

    func testCollideWithAmmoDrop() {
        let weaponSystem = player.multiWeaponComponent

        while weaponSystem.canShoot() {
            _ = weaponSystem.shoot(from: player.transformComponent.worldPosition, in: Vector2D.zero)
        }  // shoot until weapon has no ammo left

        let ammo = PaintAmmoDrop(color: .blue, position: Vector2D.zero)
        let canLoad = weaponSystem.canLoad([ammo.getAmmoObject()])
        XCTAssertTrue(canLoad) // weapon can be loaded

        player.onCollide(with: ammo) // weapon should load
        XCTAssertTrue(weaponSystem.canShoot())
        // weapon should be able to fire
    }

}

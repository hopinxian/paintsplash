//
//  EnemySpawnerTests.swift
//  paintsplashTests
//
//  Created by Cynthia Lee on 21/3/21.
//

import XCTest
@testable import paintsplash

class EnemySpawnerTests: XCTestCase {
    var redSpawner: EnemySpawner!
    var blueSpawner: EnemySpawner!
    var yellowSpawner: EnemySpawner!

    override func setUp() {
        super.setUp()
        redSpawner = EnemySpawner(initialPosition: .zero, initialVelocity: .zero, color: .red)
        blueSpawner = EnemySpawner(initialPosition: .zero, initialVelocity: .zero, color: .blue)
        yellowSpawner = EnemySpawner(initialPosition: .zero, initialVelocity: .zero, color: .yellow)
    }

    override func tearDown() {
        redSpawner = nil
        blueSpawner = nil
        yellowSpawner = nil
        super.tearDown()
    }

    func testInit() {
        XCTAssertEqual(redSpawner.color, .red)
        XCTAssertEqual(redSpawner.position, .zero)
        XCTAssertEqual(redSpawner.defaultSpeed, 0)
        XCTAssertEqual(redSpawner.velocity, .zero)
        XCTAssertEqual(redSpawner.currentHealth, 3)
        XCTAssertEqual(redSpawner.maxHealth, 3)
        XCTAssertEqual(redSpawner.state, .idle)
        XCTAssertTrue(redSpawner.currentBehaviour is SpawnEnemiesBehaviour)
    }

    func testOnCollide_PaintProjectile_correctColour() {
        for color in PaintColor.allCases {
            for subColor in color.getSubColors() {
                let projectile = PaintProjectile(color: color, radius: 10, velocity: Vector2D.left)
                let spawner = EnemySpawner(initialPosition: Vector2D.zero,
                                           initialVelocity: Vector2D.zero, color: subColor)
                spawner.onCollide(otherObject: projectile)

                XCTAssertEqual(spawner.currentHealth, spawner.maxHealth - 1)
                XCTAssertEqual(spawner.state, .hit)
            }
        }
    }

    func testOnCollide_PaintProjectile_colourDealsNoDamage() {
        let colors = PaintColor.allCases.filter { $0 != PaintColor.white }
        for color in colors {
            let nonSubColors = PaintColor.allCases.filter { !color.getSubColors().contains($0) }
            for enemyColor in nonSubColors {
                let projectile = PaintProjectile(color: color, radius: 10, velocity: Vector2D.left)
                let spawner = EnemySpawner(initialPosition: Vector2D.zero,
                                           initialVelocity: Vector2D.zero, color: enemyColor)
                spawner.onCollide(otherObject: projectile)
                XCTAssertEqual(spawner.currentHealth, spawner.maxHealth)
                XCTAssertEqual(spawner.state, .idle)
            }
        }
    }

    func testOnCollide_PaintProjectile_whiteColour() {
        for color in PaintColor.allCases {
            let projectile = PaintProjectile(color: PaintColor.white, radius: 10, velocity: Vector2D.left)
            let spawner = EnemySpawner(initialPosition: Vector2D.zero,
                                       initialVelocity: Vector2D.zero, color: color)
            spawner.onCollide(otherObject: projectile)

            XCTAssertEqual(spawner.currentHealth, spawner.maxHealth - 1)
            XCTAssertEqual(spawner.state, .hit)
        }
    }

    func testOnCollide_Player() {
        // Test that colliding with player does nothing
        let player = Player(initialPosition: .zero, initialVelocity: .zero)
        redSpawner.onCollide(otherObject: player)
        XCTAssertEqual(redSpawner.state, .idle)
        XCTAssertEqual(redSpawner.currentHealth, redSpawner.maxHealth)

        blueSpawner.onCollide(otherObject: player)
        XCTAssertEqual(blueSpawner.state, .idle)
        XCTAssertEqual(blueSpawner.currentHealth, redSpawner.maxHealth)
    }

    func testOnCollide_Enemy() {
        // Test that colliding with enemy does nothing
        let player = Player(initialPosition: .zero, initialVelocity: .zero)
        redSpawner.onCollide(otherObject: player)
        XCTAssertEqual(redSpawner.state, .idle)
        XCTAssertEqual(redSpawner.currentHealth, redSpawner.maxHealth)
    }

    func testHeal() {
        redSpawner.takeDamage(amount: 3)
        XCTAssertEqual(redSpawner.state, .die)
        XCTAssertEqual(redSpawner.currentHealth, 0)

        // Test that healing by 0 does nothing
        redSpawner.heal(amount: 0)
        XCTAssertEqual(redSpawner.state, .die)
        XCTAssertEqual(redSpawner.currentHealth, 0)

        // Test that healing
        redSpawner.heal(amount: 2)
        XCTAssertEqual(redSpawner.state, .idle)
        XCTAssertEqual(redSpawner.currentHealth, 2)

        // Test that healing is only up to max health
        redSpawner.heal(amount: 10)
        XCTAssertEqual(redSpawner.state, .idle)
        XCTAssertEqual(redSpawner.currentHealth, redSpawner.maxHealth)
    }

    func testTakeDamage() {
        // Test that taking 0 damage does nothing
        redSpawner.takeDamage(amount: 0)
        XCTAssertEqual(redSpawner.state, .hit)
        XCTAssertEqual(redSpawner.currentHealth, redSpawner.maxHealth)

        // Test that correct amount of damage is taken
        redSpawner.takeDamage(amount: 2)
        XCTAssertEqual(redSpawner.state, .hit)
        XCTAssertEqual(redSpawner.currentHealth, redSpawner.maxHealth - 2)

        // Test that health never goes to negative
        redSpawner.takeDamage(amount: 10)
        XCTAssertEqual(redSpawner.state, .die)
        XCTAssertEqual(redSpawner.currentHealth, 0)
    }

}

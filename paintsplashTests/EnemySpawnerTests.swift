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

    let gameInfo = GameInfo(playerPosition: Vector2D.zero, numberOfEnemies: 0)

    override func setUp() {
        super.setUp()
        redSpawner = EnemySpawner(initialPosition: .zero, color: .red)
        blueSpawner = EnemySpawner(initialPosition: .zero, color: .blue)
        yellowSpawner = EnemySpawner(initialPosition: .zero, color: .yellow)
    }

    override func tearDown() {
        redSpawner = nil
        blueSpawner = nil
        yellowSpawner = nil
        super.tearDown()
    }

    func testInit() {
        XCTAssertEqual(redSpawner.color, .red)
        XCTAssertEqual(redSpawner.transformComponent.worldPosition, .zero)
        XCTAssertEqual(redSpawner.healthComponent.currentHealth, 3)
        XCTAssertEqual(redSpawner.healthComponent.maxHealth, 3)
        XCTAssertTrue(redSpawner.stateComponent.currentState.getBehaviour() is DoNothingBehaviour)
    }

    func testOnCollide_PaintProjectile_correctColour() {
        for color in PaintColor.allCases {
            for subColor in color.getSubColors() {
                let projectile = PaintProjectile(color: color, position: Vector2D.zero, radius: 10, direction: Vector2D.zero)
                let spawner = EnemySpawner(initialPosition: Vector2D.zero, color: subColor)
                spawner.onCollide(with: projectile)

                XCTAssertEqual(spawner.healthComponent.currentHealth, spawner.healthComponent.maxHealth - 1)
                XCTAssertTrue(spawner.stateComponent.currentState is EnemySpawnerState.Idle)
            }
        }
    }

    func testOnCollide_PaintProjectile_colourDealsNoDamage() {
        let colors = PaintColor.allCases.filter { $0 != PaintColor.white }
        for color in colors {
            let nonSubColors = PaintColor.allCases.filter { !color.getSubColors().contains($0) }
            for enemyColor in nonSubColors {
                let projectile = PaintProjectile(color: color, position: Vector2D.zero, radius: 10, direction: Vector2D.left)
                let spawner = EnemySpawner(initialPosition: Vector2D.zero, color: enemyColor)
                spawner.onCollide(with: projectile)
                XCTAssertEqual(spawner.healthComponent.currentHealth, spawner.healthComponent.maxHealth)
                XCTAssertTrue(spawner.stateComponent.currentState is EnemySpawnerState.Idle)
            }
        }
    }

    func testOnCollide_PaintProjectile_whiteColour() {
        for color in PaintColor.allCases {
            let projectile = PaintProjectile(color: color, position: Vector2D.zero, radius: 10, direction: Vector2D.left)
            let spawner = EnemySpawner(initialPosition: Vector2D.zero, color: color)
            spawner.onCollide(with: projectile)
            GameStateManagerSystem(gameInfo: gameInfo).updateEntity(spawner, spawner)

            XCTAssertEqual(spawner.healthComponent.currentHealth, spawner.healthComponent.maxHealth - 1)
            XCTAssertTrue(spawner.stateComponent.currentState is EnemySpawnerState.Idle)
        }
    }

    func testOnCollide_Player() {
        // Test that colliding with player does nothing
        let player = Player(initialPosition: .zero)
        redSpawner.onCollide(with: player)
        XCTAssertTrue(redSpawner.stateComponent.currentState is EnemySpawnerState.Idle)
        XCTAssertEqual(redSpawner.healthComponent.currentHealth, redSpawner.healthComponent.maxHealth)

        blueSpawner.onCollide(with: player)
        XCTAssertTrue(blueSpawner.stateComponent.currentState is EnemySpawnerState.Idle)
        XCTAssertEqual(blueSpawner.healthComponent.currentHealth, blueSpawner.healthComponent.maxHealth)
    }

    func testOnCollide_Enemy() {
        // Test that colliding with enemy does nothing
        let player = Player(initialPosition: .zero)
        redSpawner.onCollide(with: player)
        XCTAssertTrue(redSpawner.stateComponent.currentState is EnemySpawnerState.Idle)
        XCTAssertEqual(redSpawner.healthComponent.currentHealth, redSpawner.healthComponent.maxHealth)
    }

    func testHeal() {
        redSpawner.takeDamage(amount: 3)
        GameStateManagerSystem(gameInfo: gameInfo).updateEntity(redSpawner, redSpawner)
        XCTAssertTrue(redSpawner.stateComponent.currentState is EnemySpawnerState.Idle)
        XCTAssertEqual(redSpawner.healthComponent.currentHealth, 0)

        // Test that healing by 0 does nothing
        redSpawner.heal(amount: 0)
        GameStateManagerSystem(gameInfo: gameInfo).updateEntity(redSpawner, redSpawner)
        XCTAssertTrue(redSpawner.stateComponent.currentState is EnemySpawnerState.Idle)
        XCTAssertEqual(redSpawner.healthComponent.currentHealth, 0)

        // Test that healing
        redSpawner.heal(amount: 2)
        GameStateManagerSystem(gameInfo: gameInfo).updateEntity(redSpawner, redSpawner)
        XCTAssertTrue(redSpawner.stateComponent.currentState is EnemySpawnerState.Idle)
        XCTAssertEqual(redSpawner.healthComponent.currentHealth, 2)

        // Test that healing is only up to max health
        redSpawner.heal(amount: 10)
        GameStateManagerSystem(gameInfo: gameInfo).updateEntity(redSpawner, redSpawner)
        XCTAssertTrue(redSpawner.stateComponent.currentState is EnemySpawnerState.Idle)
        XCTAssertEqual(redSpawner.healthComponent.currentHealth, redSpawner.healthComponent.maxHealth)
    }

    func testTakeDamage() {
        // Test that taking 0 damage does nothing
        redSpawner.takeDamage(amount: 0)
        GameStateManagerSystem(gameInfo: gameInfo).updateEntity(redSpawner, redSpawner)
        XCTAssertTrue(redSpawner.stateComponent.currentState is EnemySpawnerState.Idle)
        XCTAssertEqual(redSpawner.healthComponent.currentHealth, redSpawner.healthComponent.maxHealth)

        // Test that correct amount of damage is taken
        redSpawner.takeDamage(amount: 2)
        GameStateManagerSystem(gameInfo: gameInfo).updateEntity(redSpawner, redSpawner)
        XCTAssertTrue(redSpawner.stateComponent.currentState is EnemySpawnerState.Idle)
        XCTAssertEqual(redSpawner.healthComponent.currentHealth, redSpawner.healthComponent.maxHealth - 2)

        // Test that health never goes to negative
        redSpawner.takeDamage(amount: 10)
        GameStateManagerSystem(gameInfo: gameInfo).updateEntity(redSpawner, redSpawner)
        XCTAssertTrue(redSpawner.stateComponent.currentState is EnemySpawnerState.Idle)
        XCTAssertEqual(redSpawner.healthComponent.currentHealth, 0)
    }

}

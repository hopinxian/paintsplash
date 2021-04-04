//
//  EnemyTests.swift
//  paintsplashTests
//
//  Created by Cynthia Lee on 21/3/21.
//

import XCTest
@testable import paintsplash

class EnemyTests: XCTestCase {
    var redEnemy: Enemy!
    var orangeEnemy: Enemy!
    var yellowEnemy: Enemy!
    var blueEnemy: Enemy!
    var greenEnemy: Enemy!
    var purpleEnemy: Enemy!
    var lightRedEnemy: Enemy!
    var lightOrangeEnemy: Enemy!
    var lightYellowEnemy: Enemy!
    var lightGreenEnemy: Enemy!
    var lightBlueEnemy: Enemy!
    var lightPurpleEnemy: Enemy!
    var whiteEnemy: Enemy!

    override func setUp() {
        super.setUp()
        redEnemy = Enemy(initialPosition: .zero, color: .red)
        orangeEnemy = Enemy(initialPosition: Vector2D(25, 100), color: .orange)
        yellowEnemy = Enemy(initialPosition: Vector2D(-50, 200), color: .yellow)
        greenEnemy = Enemy(initialPosition: Vector2D(10, -100), color: .green)
        blueEnemy = Enemy(initialPosition: Vector2D(-100, -400), color: .blue)
        purpleEnemy = Enemy(initialPosition: .zero, color: .purple)

        lightRedEnemy = Enemy(initialPosition: .zero, color: .lightred)
        lightOrangeEnemy = Enemy(initialPosition: Vector2D(25, 100), color: .lightorange)
        lightYellowEnemy = Enemy(initialPosition: Vector2D(-50, 200),
                                 color: .lightyellow)
        lightGreenEnemy = Enemy(initialPosition: Vector2D(10, -100), color: .lightgreen)
        lightBlueEnemy = Enemy(initialPosition: Vector2D(-100, -400),
                               color: .lightblue)
        lightPurpleEnemy = Enemy(initialPosition: .zero, color: .lightpurple)

        whiteEnemy = Enemy(initialPosition: .zero, color: .white)
    }

    override func tearDown() {
        redEnemy = nil
        orangeEnemy = nil
        yellowEnemy = nil
        greenEnemy = nil
        blueEnemy = nil
        purpleEnemy = nil
        lightRedEnemy = nil
        lightOrangeEnemy = nil
        lightYellowEnemy = nil
        lightGreenEnemy = nil
        lightBlueEnemy = nil
        lightPurpleEnemy = nil
        whiteEnemy = nil

        super.tearDown()
    }

    func testInit() {
        XCTAssertEqual(redEnemy.color, .red)
        XCTAssertEqual(redEnemy.healthComponent.currentHealth, 1)
        XCTAssertTrue(redEnemy.stateComponent.currentState is EnemyState.Idle)
        XCTAssertEqual(redEnemy.transformComponent.worldPosition, .zero)
        XCTAssertEqual(redEnemy.moveableComponent.direction, .zero)
        XCTAssertEqual(redEnemy.healthComponent.maxHealth, 1)
        XCTAssertEqual(redEnemy.moveableComponent.speed, 1)
        XCTAssertTrue(redEnemy.stateComponent.getCurrentBehaviour() is DoNothingBehaviour)
    }

    func testSetState() {
        let manager = GameStateManagerSystem(gameInfo: GameInfo(playerPosition: Vector2D.zero, numberOfEnemies: 0))
        manager.updateEntity(redEnemy, redEnemy)
        manager.updateEntity(orangeEnemy, orangeEnemy)
        manager.updateEntity(yellowEnemy, yellowEnemy)

        XCTAssertTrue(redEnemy.stateComponent.getCurrentBehaviour() is ChasePlayerBehaviour)
        XCTAssertTrue(redEnemy.stateComponent.currentState is EnemyState.ChasingLeft)
    }

    func testOnCollide_PaintProjectile_sameColor() {
        let lightRedPaint = PaintProjectile(
            color: .lightred, position: Vector2D.zero,
            radius: 10, direction: Vector2D.zero)
        lightRedEnemy.onCollide(with: lightRedPaint)
        XCTAssertTrue(lightRedEnemy.stateComponent.currentState is EnemyState.Die)
        XCTAssertEqual(lightRedEnemy.healthComponent.currentHealth, 0)
    }

    func testOnCollide_PaintProjectile_white() {
        // Test that white defeats all enemies regardless of color
        let whitePaint = PaintProjectile(color: .white, position: Vector2D.zero, radius: 10, direction: Vector2D.zero)
        redEnemy.onCollide(with: whitePaint)
        XCTAssertTrue(redEnemy.stateComponent.currentState is EnemyState.Die)
        XCTAssertEqual(redEnemy.healthComponent.currentHealth, 0)

        lightBlueEnemy.onCollide(with: whitePaint)
        XCTAssertTrue(lightBlueEnemy.stateComponent.currentState is EnemyState.Die)
        XCTAssertEqual(lightBlueEnemy.healthComponent.currentHealth, 0)

        whiteEnemy.onCollide(with: whitePaint)
        XCTAssertTrue(whiteEnemy.stateComponent.currentState is EnemyState.Die)
        XCTAssertEqual(whiteEnemy.healthComponent.currentHealth, 0)
    }

    func testOnCollide_PaintProjectile_mixedColor_orange() {
        // Test that enemy can be killed if hit by paint containing itself as a color
        let orangePaint = PaintProjectile(color: .orange, position: Vector2D.zero, radius: 10, direction: Vector2D.zero)

        redEnemy.onCollide(with: orangePaint)
        XCTAssertTrue(redEnemy.stateComponent.currentState is EnemyState.Die)
        XCTAssertEqual(redEnemy.healthComponent.currentHealth, 0)

        yellowEnemy.onCollide(with: orangePaint)
        XCTAssertTrue(yellowEnemy.stateComponent.currentState is EnemyState.Die)
        XCTAssertEqual(yellowEnemy.healthComponent.currentHealth, 0)

        // Test that enemy of non-composite colour is not hit
        blueEnemy.onCollide(with: orangePaint)
        XCTAssertTrue(blueEnemy.stateComponent.currentState is EnemyState.Idle)
        XCTAssertEqual(blueEnemy.healthComponent.currentHealth, 1)
    }

    func testOnCollide_PaintProjectile_mixedColor_green() {
        // Test that enemy can be killed if hit by paint containing itself as a color
        let greenPaint = PaintProjectile(color: .green, position: Vector2D.zero, radius: 10, direction: Vector2D.zero)

        blueEnemy.onCollide(with: greenPaint)
        XCTAssertTrue(blueEnemy.stateComponent.currentState is EnemyState.Die)
        XCTAssertEqual(blueEnemy.healthComponent.currentHealth, 0)

        redEnemy.onCollide(with: greenPaint)
        XCTAssertTrue(redEnemy.stateComponent.currentState is EnemyState.Idle)
        XCTAssertEqual(redEnemy.healthComponent.currentHealth, 1)

        // Test that enemy of non-composite colour is not hit
        yellowEnemy.onCollide(with: greenPaint)
        XCTAssertTrue(yellowEnemy.stateComponent.currentState is EnemyState.Die)
        XCTAssertEqual(yellowEnemy.healthComponent.currentHealth, 0)
    }

    func testOnCollide_PaintProjectile_mixedColor_purple() {
        // Test that enemy can be killed if hit by paint containing itself as a color
        let purplePaint = PaintProjectile(color: .purple, position: Vector2D.zero, radius: 10, direction: Vector2D.zero)

        blueEnemy.onCollide(with: purplePaint)
        XCTAssertTrue(blueEnemy.stateComponent.currentState is EnemyState.Die)
        XCTAssertEqual(blueEnemy.healthComponent.currentHealth, 0)

        redEnemy.onCollide(with: purplePaint)
        XCTAssertTrue(redEnemy.stateComponent.currentState is EnemyState.Die)
        XCTAssertEqual(redEnemy.healthComponent.currentHealth, 0)

        // Test that enemy of non-composite colour is not hit
        yellowEnemy.onCollide(with: purplePaint)
        XCTAssertTrue(yellowEnemy.stateComponent.currentState is EnemyState.Idle)
        XCTAssertEqual(yellowEnemy.healthComponent.currentHealth, 1)
    }

    func testOnCollide_PaintProjectile_wrongColor() {
        // Test that enemy is not killed by paint which does not contain its color
        let greenPaint = PaintProjectile(color: .green, position: Vector2D.zero, radius: 10, direction: Vector2D.zero)
        lightRedEnemy.onCollide(with: greenPaint)
        XCTAssertTrue(lightRedEnemy.stateComponent.currentState is EnemyState.Idle)
        XCTAssertEqual(lightRedEnemy.healthComponent.currentHealth, 1)

        redEnemy.onCollide(with: greenPaint)
        XCTAssertTrue(redEnemy.stateComponent.currentState is EnemyState.Idle)
        XCTAssertEqual(redEnemy.healthComponent.currentHealth, 1)

        let redPaint = PaintProjectile(color: .red, position: Vector2D.zero, radius: 10, direction: Vector2D.zero)
        yellowEnemy.onCollide(with: redPaint)
        XCTAssertTrue(yellowEnemy.stateComponent.currentState is EnemyState.Idle)
        XCTAssertEqual(yellowEnemy.healthComponent.currentHealth, 1)

        greenEnemy.onCollide(with: redPaint)
        XCTAssertTrue(greenEnemy.stateComponent.currentState is EnemyState.Idle)
        XCTAssertEqual(greenEnemy.healthComponent.currentHealth, 1)
    }

    func testOnCollide_Player() {
        // Test that enemy loses health and dies when it hits player
        let player = Player(initialPosition: .zero)
        redEnemy.onCollide(with: player)
        XCTAssertTrue(redEnemy.stateComponent.currentState is EnemyState.Die)
        XCTAssertEqual(redEnemy.healthComponent.currentHealth, 0)

        yellowEnemy.onCollide(with: player)
        XCTAssertTrue(yellowEnemy.stateComponent.currentState is EnemyState.Die)
        XCTAssertEqual(yellowEnemy.healthComponent.currentHealth, 0)

        lightBlueEnemy.onCollide(with: player)
        XCTAssertTrue(lightBlueEnemy.stateComponent.currentState is EnemyState.Die)
        XCTAssertEqual(lightBlueEnemy.healthComponent.currentHealth, 0)
    }

    func testOnCollide_EnemySpawner() {
        // Test that nothing happens when enemy collides with enemy spawner
        let spawner = EnemySpawner(initialPosition: .zero, color: .red)

        redEnemy.onCollide(with: spawner)
        XCTAssertTrue(redEnemy.stateComponent.currentState is EnemyState.Idle)
        XCTAssertEqual(redEnemy.healthComponent.currentHealth, 1)

        purpleEnemy.onCollide(with: spawner)
        XCTAssertTrue(purpleEnemy.stateComponent.currentState is EnemyState.Idle)
        XCTAssertEqual(purpleEnemy.healthComponent.currentHealth, 1)

        whiteEnemy.onCollide(with: spawner)
        XCTAssertTrue(whiteEnemy.stateComponent.currentState is EnemyState.Idle)
        XCTAssertEqual(whiteEnemy.healthComponent.currentHealth, 1)
    }

    func testOnCollide_otherEnemy() {
        // Test that nothing happens when enemy collides with any other enemy
        greenEnemy.onCollide(with: whiteEnemy)
        XCTAssertTrue(greenEnemy.stateComponent.currentState is EnemyState.Idle)
        XCTAssertEqual(greenEnemy.healthComponent.currentHealth, 1)
        XCTAssertTrue(whiteEnemy.stateComponent.currentState is EnemyState.Idle)
        XCTAssertEqual(whiteEnemy.healthComponent.currentHealth, 1)
    }

    func testHeal() {
        lightRedEnemy.takeDamage(amount: 1)
        XCTAssertTrue(lightRedEnemy.stateComponent.currentState is EnemyState.Die)
        XCTAssertEqual(lightRedEnemy.healthComponent.currentHealth, 0)

        // Test that healing by 0 does nothing
        lightRedEnemy.heal(amount: 0)
        XCTAssertTrue(lightRedEnemy.stateComponent.currentState is EnemyState.Die)
        XCTAssertEqual(lightRedEnemy.healthComponent.currentHealth, 0)

        // Test that enemy can heal by positive amount up to maximum health
        // Enemy still dead
        lightRedEnemy.heal(amount: 2)
        XCTAssertTrue(lightRedEnemy.stateComponent.currentState is EnemyState.Die)
        XCTAssertEqual(lightRedEnemy.healthComponent.currentHealth, lightRedEnemy.healthComponent.maxHealth)
    }

    func testTakeDamage() {
        // Test that taking 0 damage does nothing
        yellowEnemy.takeDamage(amount: 0)
        XCTAssertTrue(yellowEnemy.stateComponent.currentState is EnemyState.Idle)
        XCTAssertEqual(yellowEnemy.healthComponent.currentHealth, 1)

        lightRedEnemy.takeDamage(amount: 1)
        XCTAssertTrue(lightRedEnemy.stateComponent.currentState is EnemyState.Die)
        XCTAssertEqual(lightRedEnemy.healthComponent.currentHealth, 0)

        // Test that health does not become negative when damage exceeds current health
        blueEnemy.takeDamage(amount: 2)
        XCTAssertTrue(blueEnemy.stateComponent.currentState is EnemyState.Die)
        XCTAssertEqual(blueEnemy.healthComponent.currentHealth, 0)
    }
}

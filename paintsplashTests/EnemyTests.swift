//
//  EnemyTests.swift
//  paintsplashTests
//
//  Created by Cynthia Lee on 21/3/21.
//
//  swiftlint:disable type_body_length

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
        redEnemy = Enemy(initialPosition: .zero, initialVelocity: .zero, color: .red)
        orangeEnemy = Enemy(initialPosition: Vector2D(25, 100), initialVelocity: Vector2D(0.4, 0.5), color: .orange)
        yellowEnemy = Enemy(initialPosition: Vector2D(-50, 200), initialVelocity: Vector2D(-0.4, 0.5), color: .yellow)
        greenEnemy = Enemy(initialPosition: Vector2D(10, -100), initialVelocity: .zero, color: .green)
        blueEnemy = Enemy(initialPosition: Vector2D(-100, -400), initialVelocity: Vector2D(0.4, 0.5), color: .blue)
        purpleEnemy = Enemy(initialPosition: .zero, initialVelocity: Vector2D(0.4, 0.5), color: .purple)

        lightRedEnemy = Enemy(initialPosition: .zero, initialVelocity: .zero, color: .lightred)
        lightOrangeEnemy = Enemy(initialPosition: Vector2D(25, 100), initialVelocity: Vector2D(0.4, 0.5),
                                 color: .lightorange)
        lightYellowEnemy = Enemy(initialPosition: Vector2D(-50, 200), initialVelocity: Vector2D(-0.4, 0.5),
                                 color: .lightyellow)
        lightGreenEnemy = Enemy(initialPosition: Vector2D(10, -100), initialVelocity: .zero, color: .lightgreen)
        lightBlueEnemy = Enemy(initialPosition: Vector2D(-100, -400), initialVelocity: Vector2D(0.4, 0.5),
                               color: .lightblue)
        lightPurpleEnemy = Enemy(initialPosition: .zero, initialVelocity: Vector2D(0.4, 0.5), color: .lightpurple)

        whiteEnemy = Enemy(initialPosition: .zero, initialVelocity: .zero, color: .white)
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
        XCTAssertEqual(redEnemy.currentHealth, 1)
        XCTAssertFalse(redEnemy.isHit)
        XCTAssertEqual(redEnemy.position, .zero)
        XCTAssertEqual(redEnemy.velocity, .zero)
        XCTAssertEqual(redEnemy.maxHealth, 1)
        XCTAssertEqual(redEnemy.defaultSpeed, 1)
        XCTAssertTrue(redEnemy.currentBehaviour is ApproachPointBehaviour)

        XCTAssertEqual(lightOrangeEnemy.color, .lightorange)
        XCTAssertEqual(lightOrangeEnemy.currentHealth, 1)
        XCTAssertFalse(lightOrangeEnemy.isHit)
        XCTAssertEqual(lightOrangeEnemy.position, Vector2D(25, 100))
        XCTAssertEqual(lightOrangeEnemy.velocity, Vector2D(0.4, 0.5))
        XCTAssertEqual(lightOrangeEnemy.maxHealth, 1)
        XCTAssertEqual(lightOrangeEnemy.defaultSpeed, 1)
        XCTAssertTrue(lightOrangeEnemy.currentBehaviour is ApproachPointBehaviour)

        XCTAssertEqual(yellowEnemy.color, .yellow)
        XCTAssertEqual(yellowEnemy.currentHealth, 1)
        XCTAssertFalse(yellowEnemy.isHit)
        XCTAssertEqual(yellowEnemy.position, Vector2D(-50, 200))
        XCTAssertEqual(yellowEnemy.velocity, Vector2D(-0.4, 0.5))
        XCTAssertEqual(yellowEnemy.maxHealth, 1)
        XCTAssertEqual(yellowEnemy.defaultSpeed, 1)
        XCTAssertTrue(yellowEnemy.currentBehaviour is ApproachPointBehaviour)

        XCTAssertEqual(lightGreenEnemy.color, .lightgreen)
        XCTAssertEqual(lightGreenEnemy.currentHealth, 1)
        XCTAssertFalse(lightGreenEnemy.isHit)
        XCTAssertEqual(lightGreenEnemy.position, Vector2D(10.0, -100.0))
        XCTAssertEqual(lightGreenEnemy.velocity, .zero)
        XCTAssertEqual(lightGreenEnemy.maxHealth, 1)
        XCTAssertEqual(lightGreenEnemy.defaultSpeed, 1)
        XCTAssertTrue(lightGreenEnemy.currentBehaviour is ApproachPointBehaviour)
    }

    func testSetState() {
        redEnemy.setState()
        orangeEnemy.setState()
        yellowEnemy.setState()

        XCTAssertEqual(redEnemy.state, .idle)
        XCTAssertEqual(orangeEnemy.state, .moveRight)
        XCTAssertEqual(yellowEnemy.state, .moveLeft)
    }

    func testOnCollide_PaintProjectile_sameColor() {
        let lightRedPaint = PaintProjectile(color: .lightred, radius: 10, velocity: .zero)
        lightRedEnemy.onCollide(otherObject: lightRedPaint)
        XCTAssertEqual(lightRedEnemy.state, .die)
        XCTAssertEqual(lightRedEnemy.currentHealth, 0)

        let orangePaint = PaintProjectile(color: .orange, radius: 10, velocity: .zero)
        orangeEnemy.onCollide(otherObject: orangePaint)
        XCTAssertEqual(orangeEnemy.state, .die)
        XCTAssertEqual(orangeEnemy.currentHealth, 0)

        let purplePaint = PaintProjectile(color: .purple, radius: 10, velocity: .zero)
        purpleEnemy.onCollide(otherObject: purplePaint)
        XCTAssertEqual(purpleEnemy.state, .die)
        XCTAssertEqual(purpleEnemy.currentHealth, 0)
    }

    func testOnCollide_PaintProjectile_white() {
        // Test that white defeats all enemies regardless of color
        let whitePaint = PaintProjectile(color: .white, radius: 10, velocity: .zero)
        redEnemy.onCollide(otherObject: whitePaint)
        XCTAssertEqual(redEnemy.state, .die)
        XCTAssertEqual(redEnemy.currentHealth, 0)

        lightBlueEnemy.onCollide(otherObject: whitePaint)
        XCTAssertEqual(lightBlueEnemy.state, .die)
        XCTAssertEqual(lightBlueEnemy.currentHealth, 0)

        whiteEnemy.onCollide(otherObject: whitePaint)
        XCTAssertEqual(whiteEnemy.state, .die)
        XCTAssertEqual(whiteEnemy.currentHealth, 0)
    }

    func testOnCollide_PaintProjectile_mixedColor_orange() {
        // Test that enemy can be killed if hit by paint containing itself as a color
        let orangePaint = PaintProjectile(color: .orange, radius: 10, velocity: .zero)

        redEnemy.onCollide(otherObject: orangePaint)
        XCTAssertEqual(redEnemy.state, .die)
        XCTAssertEqual(redEnemy.currentHealth, 0)

        yellowEnemy.onCollide(otherObject: orangePaint)
        XCTAssertEqual(yellowEnemy.state, .die)
        XCTAssertEqual(yellowEnemy.currentHealth, 0)

        // Test that enemy of non-composite colour is not hit
        blueEnemy.onCollide(otherObject: orangePaint)
        XCTAssertEqual(blueEnemy.state, .idle)
        XCTAssertEqual(blueEnemy.currentHealth, 1)
    }

    func testOnCollide_PaintProjectile_mixedColor_green() {
        // Test that enemy can be killed if hit by paint containing itself as a color
        let greenPaint = PaintProjectile(color: .green, radius: 10, velocity: .zero)

        blueEnemy.onCollide(otherObject: greenPaint)
        XCTAssertEqual(blueEnemy.state, .die)
        XCTAssertEqual(blueEnemy.currentHealth, 0)

        redEnemy.onCollide(otherObject: greenPaint)
        XCTAssertEqual(redEnemy.state, .idle)
        XCTAssertEqual(redEnemy.currentHealth, 1)

        // Test that enemy of non-composite colour is not hit
        yellowEnemy.onCollide(otherObject: greenPaint)
        XCTAssertEqual(yellowEnemy.state, .die)
        XCTAssertEqual(yellowEnemy.currentHealth, 0)
    }

    func testOnCollide_PaintProjectile_mixedColor_purple() {
        // Test that enemy can be killed if hit by paint containing itself as a color
        let purplePaint = PaintProjectile(color: .purple, radius: 10, velocity: .zero)

        blueEnemy.onCollide(otherObject: purplePaint)
        XCTAssertEqual(blueEnemy.state, .die)
        XCTAssertEqual(blueEnemy.currentHealth, 0)

        redEnemy.onCollide(otherObject: purplePaint)
        XCTAssertEqual(redEnemy.state, .die)
        XCTAssertEqual(redEnemy.currentHealth, 0)

        // Test that enemy of non-composite colour is not hit
        yellowEnemy.onCollide(otherObject: purplePaint)
        XCTAssertEqual(yellowEnemy.state, .idle)
        XCTAssertEqual(yellowEnemy.currentHealth, 1)
    }

    func testOnCollide_PaintProjectile_wrongColor() {
        // Test that enemy is not killed by paint which does not contain its color
        let greenPaint = PaintProjectile(color: .green, radius: 10, velocity: .zero)
        lightRedEnemy.onCollide(otherObject: greenPaint)
        XCTAssertEqual(lightRedEnemy.state, .idle)
        XCTAssertEqual(lightRedEnemy.currentHealth, 1)

        redEnemy.onCollide(otherObject: greenPaint)
        XCTAssertEqual(redEnemy.state, .idle)
        XCTAssertEqual(redEnemy.currentHealth, 1)

        let redPaint = PaintProjectile(color: .red, radius: 10, velocity: .zero)
        yellowEnemy.onCollide(otherObject: redPaint)
        XCTAssertEqual(yellowEnemy.state, .idle)
        XCTAssertEqual(yellowEnemy.currentHealth, 1)

        greenEnemy.onCollide(otherObject: redPaint)
        XCTAssertEqual(greenEnemy.state, .idle)
        XCTAssertEqual(greenEnemy.currentHealth, 1)
    }

    func testOnCollide_Player() {
        // Test that enemy loses health and dies when it hits player
        let player = Player(initialPosition: .zero, initialVelocity: .zero)
        redEnemy.onCollide(otherObject: player)
        XCTAssertEqual(redEnemy.state, .die)
        XCTAssertEqual(redEnemy.currentHealth, 0)

        yellowEnemy.onCollide(otherObject: player)
        XCTAssertEqual(yellowEnemy.state, .die)
        XCTAssertEqual(yellowEnemy.currentHealth, 0)

        lightBlueEnemy.onCollide(otherObject: player)
        XCTAssertEqual(lightBlueEnemy.state, .die)
        XCTAssertEqual(lightBlueEnemy.currentHealth, 0)
    }

    func testOnCollide_EnemySpawner() {
        // Test that nothing happens when enemy collides with enemy spawner
        let spawner = EnemySpawner(initialPosition: .zero, initialVelocity: .zero, color: .red)

        redEnemy.onCollide(otherObject: spawner)
        XCTAssertEqual(redEnemy.state, .idle)
        XCTAssertEqual(redEnemy.currentHealth, 1)

        purpleEnemy.onCollide(otherObject: spawner)
        XCTAssertEqual(purpleEnemy.state, .idle)
        XCTAssertEqual(purpleEnemy.currentHealth, 1)

        whiteEnemy.onCollide(otherObject: spawner)
        XCTAssertEqual(whiteEnemy.state, .idle)
        XCTAssertEqual(whiteEnemy.currentHealth, 1)
    }

    func testOnCollide_otherEnemy() {
        // Test that nothing happens when enemy collides with any other enemy
        greenEnemy.onCollide(otherObject: whiteEnemy)
        XCTAssertEqual(greenEnemy.state, .idle)
        XCTAssertEqual(greenEnemy.currentHealth, 1)
        XCTAssertEqual(whiteEnemy.state, .idle)
        XCTAssertEqual(whiteEnemy.currentHealth, 1)

        lightPurpleEnemy.onCollide(otherObject: redEnemy)
        XCTAssertEqual(redEnemy.state, .idle)
        XCTAssertEqual(redEnemy.currentHealth, 1)
        XCTAssertEqual(lightPurpleEnemy.state, .idle)
        XCTAssertEqual(lightPurpleEnemy.currentHealth, 1)

        lightYellowEnemy.onCollide(otherObject: blueEnemy)
        XCTAssertEqual(blueEnemy.state, .idle)
        XCTAssertEqual(blueEnemy.currentHealth, 1)
        XCTAssertEqual(lightYellowEnemy.state, .idle)
        XCTAssertEqual(lightYellowEnemy.currentHealth, 1)
    }

    func testHeal() {
        lightRedEnemy.takeDamage(amount: 1)
        XCTAssertEqual(lightRedEnemy.state, .die)
        XCTAssertEqual(lightRedEnemy.currentHealth, 0)

        // Test that healing by 0 does nothing
        lightRedEnemy.heal(amount: 0)
        XCTAssertEqual(lightRedEnemy.state, .die)
        XCTAssertEqual(lightRedEnemy.currentHealth, 0)

        // Test that enemy can heal by positive amount up to maximum health
        lightRedEnemy.heal(amount: 2)
        XCTAssertEqual(lightRedEnemy.state, .idle)
        XCTAssertEqual(lightRedEnemy.currentHealth, lightRedEnemy.maxHealth)
    }

    func testTakeDamage() {
        // Test that taking 0 damage does nothing
        yellowEnemy.takeDamage(amount: 0)
        XCTAssertEqual(yellowEnemy.state, .hit)
        XCTAssertEqual(yellowEnemy.currentHealth, 1)

        lightRedEnemy.takeDamage(amount: 1)
        XCTAssertEqual(lightRedEnemy.state, .die)
        XCTAssertEqual(lightRedEnemy.currentHealth, 0)

        // Test that health does not become negative when damage exceeds current health
        blueEnemy.takeDamage(amount: 2)
        XCTAssertEqual(blueEnemy.state, .die)
        XCTAssertEqual(blueEnemy.currentHealth, 0)
    }
}

//
//  CanvasTests.swift
//  paintsplashTests
//
//  Created by Cynthia Lee on 20/3/21.
//

import XCTest
@testable import paintsplash

class CanvasTests: XCTestCase {
    var canvas: Canvas!

    override func setUp() {
        super.setUp()
        canvas = Canvas(initialPosition: .zero, velocity: .zero, size: Vector2D(50, 50), endX: 100)
    }

    override func tearDown() {
        canvas = nil
        super.tearDown()
    }

    func testInitialization() {
        XCTAssertEqual(canvas.position, Vector2D.zero)
        XCTAssertEqual(canvas.zPosition, Constants.ZPOSITION_UI_ELEMENT)
        XCTAssertEqual(canvas.colors, [])
        XCTAssertEqual(canvas.velocity, .zero)
        XCTAssertEqual(canvas.defaultSpeed, 0)
        XCTAssertEqual(canvas.transform.size, Vector2D(50, 50))
        XCTAssertEqual(canvas.state, .idle)
        XCTAssertTrue(canvas.currentBehaviour is CanvasBehaviour)
    }

    func testOnCollide_PaintProjectile() {
        let paint1 = PaintProjectile(color: .blue, radius: 10, velocity: .zero)
        canvas.onCollide(otherObject: paint1)

        XCTAssertEqual(canvas.colors.count, 1)
        XCTAssertTrue(canvas.colors.contains(.blue))

        let paint2 = PaintProjectile(color: .lightpurple, radius: 10, velocity: .zero)
        canvas.onCollide(otherObject: paint2)
        XCTAssertEqual(canvas.colors.count, 2)
        XCTAssertTrue(canvas.colors.contains(.blue))
        XCTAssertTrue(canvas.colors.contains(.lightpurple))

        let paint3 = PaintProjectile(color: .white, radius: 10, velocity: .zero)
        canvas.onCollide(otherObject: paint3)
        XCTAssertEqual(canvas.colors.count, 3)
        XCTAssertTrue(canvas.colors.contains(.blue))
        XCTAssertTrue(canvas.colors.contains(.lightpurple))
        XCTAssertTrue(canvas.colors.contains(.white))
    }

    func testOnCollide_EnemyBlob() {
        let blob = Enemy(initialPosition: .zero, initialVelocity: .zero, color: .red)
        canvas.onCollide(otherObject: blob)

        // Test that canvas colliding with enemy blob does not change canvas colors
        XCTAssertEqual(canvas.colors.count, 0)
        XCTAssertFalse(canvas.colors.contains(.red))
    }

    func testOnCollide_EnemySpawner() {
        let spawner = EnemySpawner(initialPosition: .zero, initialVelocity: .zero, color: .green)
        canvas.onCollide(otherObject: spawner)

        // Test that canvas colliding with enemy spawner does not change canvas colors
        XCTAssertEqual(canvas.colors.count, 0)
        XCTAssertFalse(canvas.colors.contains(.green))
    }

    func testOnCollide_Player() {
        let player = Player(initialPosition: .zero, initialVelocity: .zero)
        canvas.onCollide(otherObject: player)
        // Test that canvas colliding with player does not change canvas colors
        XCTAssertEqual(canvas.colors.count, 0)
    }

}

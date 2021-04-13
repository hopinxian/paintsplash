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
        canvas = Canvas(initialPosition: .zero, direction: .zero, size: Vector2D(50, 50), endX: 100)
    }

    override func tearDown() {
        canvas = nil
        super.tearDown()
    }

    func testInitialization() {
        XCTAssertEqual(canvas.transformComponent.worldPosition, Vector2D.zero)
        XCTAssertEqual(canvas.renderComponent.zPosition, Constants.ZPOSITION_CANVAS)
        XCTAssertEqual(canvas.colors, [])
        XCTAssertEqual(canvas.moveableComponent.direction, .zero)
        XCTAssertEqual(canvas.moveableComponent.speed, Constants.CANVAS_MOVE_SPEED)
        XCTAssertEqual(canvas.transformComponent.size, Constants.CANVAS_SIZE)
        XCTAssertTrue(canvas.stateComponent.getCurrentBehaviour() is DoNothingBehaviour)
        XCTAssertTrue(canvas.stateComponent.currentState is CanvasState.Moving)
    }

    func testOnCollide_PaintProjectile() {
        let paint1 = PaintProjectile(color: .blue, position: Vector2D.zero, radius: 10, direction: .zero)

        canvas.collisionComponent.onCollide(with: paint1)

        XCTAssertEqual(canvas.colors.count, 1)
        XCTAssertTrue(canvas.colors.contains(.blue))

        let paint2 = PaintProjectile(color: .lightpurple, position: Vector2D.zero, radius: 10, direction: .zero)
        canvas.collisionComponent.onCollide(with: paint2)
        XCTAssertEqual(canvas.colors.count, 2)
        XCTAssertTrue(canvas.colors.contains(.blue))
        XCTAssertTrue(canvas.colors.contains(.lightpurple))

        let paint3 = PaintProjectile(color: .white, position: Vector2D.zero, radius: 10, direction: .zero)
        canvas.collisionComponent.onCollide(with: paint3)
        XCTAssertEqual(canvas.colors.count, 3)
        XCTAssertTrue(canvas.colors.contains(.blue))
        XCTAssertTrue(canvas.colors.contains(.lightpurple))
        XCTAssertTrue(canvas.colors.contains(.white))
    }

    func testOnCollide_EnemyBlob() {
        let blob = Enemy(initialPosition: .zero, color: .red)
        canvas.collisionComponent.onCollide(with: blob)

        // Test that canvas colliding with enemy blob does not change canvas colors
        XCTAssertEqual(canvas.colors.count, 0)
        XCTAssertFalse(canvas.colors.contains(.red))
    }

    func testOnCollide_EnemySpawner() {
        let spawner = EnemySpawner(initialPosition: .zero, color: .green)
        canvas.collisionComponent.onCollide(with: spawner)

        // Test that canvas colliding with enemy spawner does not change canvas colors
        XCTAssertEqual(canvas.colors.count, 0)
        XCTAssertFalse(canvas.colors.contains(.green))
    }

    func testOnCollide_Player() {
        let player = Player(initialPosition: .zero)
        canvas.collisionComponent.onCollide(with: player)
        // Test that canvas colliding with player does not change canvas colors
        XCTAssertEqual(canvas.colors.count, 0)
    }

}

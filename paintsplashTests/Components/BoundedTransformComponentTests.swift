//
//  BoundedTransformComponentTests.swift
//  paintsplashTests
//
//  Created by admin on 3/4/21.
//

import XCTest
@testable import paintsplash

class BoundedTransformComponentTests: XCTestCase {

    let position = Vector2D(30, 30)
    let component = BoundedTransformComponent(
        position: Vector2D(30, 30),
        rotation: 0,
        size: Vector2D(20, 20),
        bounds: Rect(minX: 0, maxX: 50, minY: 0, maxY: 50))

    func testSetPosition() {
        component.localPosition = Vector2D(60, 60)
        XCTAssertEqual(component.localPosition, position)

        component.localPosition = position
        XCTAssertEqual(component.localPosition, position)

        component.localPosition = Vector2D(0, 0)
        XCTAssertEqual(component.localPosition, position)

    }
}

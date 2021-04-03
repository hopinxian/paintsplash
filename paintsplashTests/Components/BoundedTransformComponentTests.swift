//
//  BoundedTransformComponentTests.swift
//  paintsplashTests
//
//  Created by admin on 3/4/21.
//

import XCTest
@testable import paintsplash

class BoundedTransformComponentTests: XCTestCase {

    let component = BoundedTransformComponent(
        position: .zero,
        rotation: 0,
        size: Vector2D(20, 20),
        bounds: Rect(minX: 0, maxX: 50, minY: 0, maxY: 50))

    func testConstruct() {
        XCTAssertEqual(component.bounds, Rect(minX: 0, maxX: 50, minY: 0, maxY: 50))
        XCTAssertEqual(component.size, Vector2D(20, 20))

    }
}

//
//  HealthComponentTests.swift
//  paintsplashTests
//
//  Created by admin on 3/4/21.
//

import XCTest
@testable import paintsplash

class HealthComponentTests: XCTestCase {

    func testConstruct() throws {
        let component = HealthComponent(currentHealth: 4, maxHealth: 10)
        XCTAssertEqual(component.currentHealth, 4)
        XCTAssertEqual(component.maxHealth, 10)
    }

    func testSetCurrentHealth() {
        let component = HealthComponent(currentHealth: 4, maxHealth: 10)
        component.currentHealth = 20
        XCTAssertEqual(component.currentHealth, 10)

        component.currentHealth = -5
        XCTAssertEqual(component.currentHealth, 0)

        component.currentHealth += 8
        XCTAssertEqual(component.currentHealth, 8)
    }
}

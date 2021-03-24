//
//  AttackButtonUITests.swift
//  paintsplashUITests
//
//  Created by Praveen Bala on 21/3/21.
//

import XCTest

class AttackButtonUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testHandleReturnToBasePosition() {
        let app = XCUIApplication()
        let attackButton = app.otherElements["attack-button"]
        let projectile = app.otherElements["Projectile"]
        app.launch()
        XCTAssertTrue(attackButton.waitForExistence(timeout: 1))
        attackButton.tap()
        XCTAssertTrue(projectile.waitForExistence(timeout: 1))
    }

    func testPressAttackButtonDragOutRelease() {
        let app = XCUIApplication()

        let attackButton = app.otherElements["attack-button"]
        let projectile = app.otherElements["Projectile"]
        let player = app.otherElements["Player"]

        app.launch()
        XCTAssertTrue(attackButton.waitForExistence(timeout: 1))
        attackButton.press(forDuration: 1, thenDragTo: player)
        XCTAssertTrue(projectile.waitForExistence(timeout: 1))
    }

    func testPressOutsideThenDragToButtonAndRelease() {
        let app = XCUIApplication()

        let attackButton = app.otherElements["attack-button"]
        let projectile = app.otherElements["Projectile"]
        let player = app.otherElements["Player"]

        app.launch()
        XCTAssertTrue(attackButton.waitForExistence(timeout: 1))
        player.press(forDuration: 1, thenDragTo: attackButton)
        XCTAssertFalse(projectile.waitForExistence(timeout: 1))
    }
}

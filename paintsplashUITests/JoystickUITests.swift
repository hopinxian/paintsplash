//
//  JoystickUITests.swift
//  paintsplashUITests
//
//  Created by Praveen Bala on 21/3/21.
//

import XCTest

class JoystickUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testHandleReturnToBasePosition() {
        let app = XCUIApplication()

        let handle = app.otherElements["joystick-foreground"]
        let background = app.otherElements["joystick-background"]

        app.launch()
        XCTAssert(handle.waitForExistence(timeout: 1))
        handle.press(forDuration: 1,
                     thenDragTo: app.otherElements["Player"],
                     withVelocity: .default,
                     thenHoldForDuration: 2)

        XCTAssertTrue(background.frame.contains(handle.frame))
    }
}

//
//  AnimationComponentTests.swift
//  paintsplashTests
//
//  Created by admin on 3/4/21.
//

import XCTest
@testable import paintsplash

class AnimationComponentTests: XCTestCase {

    let component = AnimationComponent()
    let currentAnimation = "playerBrushAttackLeft"
    let animationToPlay = "playerBrushAttackRight"
    let nextAnimation = "playerBrushIdleLeft"

    override func setUp() {
        super.setUp()
        component.currentAnimation = currentAnimation
        component.animationToPlay = animationToPlay
        component.animationIsPlaying = true
    }

    func testAnimate_noCallback() {
        component.animate(animation: nextAnimation, interupt: false)
        XCTAssertEqual(component.currentAnimation, currentAnimation)
        XCTAssertEqual(component.animationToPlay, animationToPlay)
        XCTAssertNil(component.callBack)
        XCTAssertTrue(component.animationIsPlaying)

        component.animate(animation: nextAnimation, interupt: true)
        XCTAssertEqual(component.currentAnimation, currentAnimation)
        XCTAssertEqual(component.animationToPlay, nextAnimation)
    }

    func testAnimate() {
        let callback = { print("callback") }
        component.animate(animation: nextAnimation, interupt: false, callBack: callback)
        XCTAssertEqual(component.currentAnimation, currentAnimation)
        XCTAssertEqual(component.animationToPlay, animationToPlay)
        XCTAssertNil(component.callBack)

        component.animate(animation: nextAnimation, interupt: true, callBack: callback)
        XCTAssertEqual(component.currentAnimation, currentAnimation)
        XCTAssertEqual(component.animationToPlay, nextAnimation)
        XCTAssertNotNil(component.callBack)
    }
}

//
//  PaintGunTests.swift
//  paintsplashTests
//
//  Created by Ho Pin Xian on 16/3/21.
//

import XCTest
@testable import paintsplash

class PaintGunTests: XCTestCase {

    let direction = Vector2D.zero

    func testLoad_loadThreeAmmo() {
        let paintgun = PaintGun()
        let loadAmmo = [AmmoHelper.red, AmmoHelper.blue, AmmoHelper.blue]
        for ammo in loadAmmo {
            paintgun.load(ammo)
        }

        let expectedColor = [PaintColor.blue, PaintColor.purple, PaintColor.purple]
        for color in expectedColor {
            XCTAssertEqual(paintgun.shoot(in: direction)?.getColor(), color)
        }
        XCTAssertNil(paintgun.shoot(in: direction)?.getColor())
    }

    func testLoad_loadOneAmmo() {
        let paintgun = PaintGun()
        paintgun.load(AmmoHelper.red)

        XCTAssertEqual(paintgun.shoot(in: direction)?.getColor(), PaintColor.red)
        XCTAssertNil(paintgun.shoot(in: direction)?.getColor())
    }

    func testLoad_loadMultipleAmmo() {
        let paintgun = PaintGun()
        paintgun.load([AmmoHelper.red,
                       AmmoHelper.red,
                       AmmoHelper.yellow,
                       AmmoHelper.blue,
                       AmmoHelper.orange,
                       AmmoHelper.white,
                       AmmoHelper.purple,
                       AmmoHelper.white])
        var expectedColor = [PaintColor.blue, PaintColor.orange, PaintColor.orange, PaintColor.red]

        for color in expectedColor {
            XCTAssertEqual(paintgun.shoot(in: direction)?.getColor(), color)
        }
        XCTAssertNil(paintgun.shoot(in: direction)?.getColor())

        paintgun.load([AmmoHelper.purple, AmmoHelper.orange, AmmoHelper.green, AmmoHelper.red, AmmoHelper.white])

        expectedColor = [PaintColor.red, PaintColor.green, PaintColor.orange, PaintColor.purple]
        for color in expectedColor {
            XCTAssertEqual(paintgun.shoot(in: direction)?.getColor(), color)
        }
        XCTAssertNil(paintgun.shoot(in: direction)?.getColor())
    }
}

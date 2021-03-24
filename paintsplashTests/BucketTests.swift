//
//  BucketTests.swift
//  paintsplashTests
//
//  Created by Ho Pin Xian on 16/3/21.
//

import XCTest
@testable import paintsplash

class BucketTests: XCTestCase {

    let direction = Vector2D.zero

    func testLoad_loadThreeAmmo() {
        let bucket = Bucket()
        let loadAmmo = [AmmoHelper.red, AmmoHelper.blue, AmmoHelper.blue]
        for ammo in loadAmmo {
            bucket.load(ammo)
        }

        let expectedColor = [PaintColor.purple, PaintColor.purple, PaintColor.blue]
        for color in expectedColor {
            XCTAssertEqual(bucket.shoot(in: direction)?.getColor(), color)
        }
        XCTAssertNil(bucket.shoot(in: direction)?.getColor())
    }

    func testLoad_loadOneAmmo() {
        let bucket = Bucket()
        bucket.load(AmmoHelper.red)

        XCTAssertEqual(bucket.shoot(in: direction)?.getColor(), PaintColor.red)
        XCTAssertNil(bucket.shoot(in: direction)?.getColor())
    }

    func testLoad_loadMultipleAmmo() {
        let bucket = Bucket()
        bucket.load([AmmoHelper.red,
                     AmmoHelper.red,
                     AmmoHelper.yellow,
                     AmmoHelper.blue,
                     AmmoHelper.orange,
                     AmmoHelper.white,
                     AmmoHelper.purple,
                     AmmoHelper.white])

        var expectedColor = [PaintColor.red, PaintColor.orange, PaintColor.orange, PaintColor.blue]
        for color in expectedColor {
            XCTAssertEqual(bucket.shoot(in: direction)?.getColor(), color)
        }
        XCTAssertNil(bucket.shoot(in: direction)?.getColor())

        bucket.load([AmmoHelper.purple, AmmoHelper.orange, AmmoHelper.green, AmmoHelper.red, AmmoHelper.white])

        expectedColor = [PaintColor.purple, PaintColor.orange, PaintColor.green, PaintColor.red]
        for color in expectedColor {
            XCTAssertEqual(bucket.shoot(in: direction)?.getColor(), color)
        }
        XCTAssertNil(bucket.shoot(in: direction)?.getColor())
    }
}

//
//  BucketTests.swift
//  paintsplashTests
//
//  Created by Ho Pin Xian on 16/3/21.
//

import XCTest
@testable import paintsplash

class BucketTests: XCTestCase {

    func testLoad_loadThreeAmmo() {
        let bucket = Bucket()
        bucket.load(AmmoHelper.red)
        bucket.load(AmmoHelper.blue)
        bucket.load(AmmoHelper.blue)

        XCTAssertEqual(bucket.shoot()?.getColor(), PaintColor.purple)
        XCTAssertEqual(bucket.shoot()?.getColor(), PaintColor.purple)
        XCTAssertEqual(bucket.shoot()?.getColor(), PaintColor.blue)
        XCTAssertNil(bucket.shoot()?.getColor())
    }
    
    func testLoad_loadOneAmmo() {
        let bucket = Bucket()
        bucket.load(AmmoHelper.red)
        
        XCTAssertEqual(bucket.shoot()?.getColor(), PaintColor.red)
        XCTAssertNil(bucket.shoot()?.getColor())
    }
    
    func testLoad_loadMultipleAmmo() {
        let bucket = Bucket()
        bucket.load([AmmoHelper.red, AmmoHelper.red, AmmoHelper.yellow, AmmoHelper.blue, AmmoHelper.orange, AmmoHelper.white, AmmoHelper.purple, AmmoHelper.white])
        
        XCTAssertEqual(bucket.shoot()?.getColor(), PaintColor.red)
        XCTAssertEqual(bucket.shoot()?.getColor(), PaintColor.orange)
        XCTAssertEqual(bucket.shoot()?.getColor(), PaintColor.orange)
        XCTAssertEqual(bucket.shoot()?.getColor(), PaintColor.blue)
        XCTAssertEqual(bucket.shoot()?.getColor(), PaintColor.lightorange)
        XCTAssertEqual(bucket.shoot()?.getColor(), PaintColor.lightorange)
        XCTAssertEqual(bucket.shoot()?.getColor(), PaintColor.lightpurple)
        XCTAssertEqual(bucket.shoot()?.getColor(), PaintColor.lightpurple)
        XCTAssertNil(bucket.shoot()?.getColor())
        
        bucket.load([AmmoHelper.purple, AmmoHelper.orange, AmmoHelper.green, AmmoHelper.red, AmmoHelper.white])
        
        XCTAssertEqual(bucket.shoot()?.getColor(), PaintColor.purple)
        XCTAssertEqual(bucket.shoot()?.getColor(), PaintColor.orange)
        XCTAssertEqual(bucket.shoot()?.getColor(), PaintColor.green)
        XCTAssertEqual(bucket.shoot()?.getColor(), PaintColor.lightred)
        XCTAssertEqual(bucket.shoot()?.getColor(), PaintColor.lightred)
        XCTAssertNil(bucket.shoot()?.getColor())
    }
    
    func testLoad_twoWhite() {
        let bucket = Bucket()
        bucket.load([AmmoHelper.red, AmmoHelper.red, AmmoHelper.yellow, AmmoHelper.blue, AmmoHelper.orange, AmmoHelper.white, AmmoHelper.purple, AmmoHelper.white])
        bucket.load([AmmoHelper.white])
        for _ in 0..<9 {
            XCTAssertEqual(bucket.shoot()?.getColor(), PaintColor.white)
        }
        XCTAssertNil(bucket.shoot()?.getColor())
    }
}

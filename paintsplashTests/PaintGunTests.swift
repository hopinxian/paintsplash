//
//  PaintGunTests.swift
//  paintsplashTests
//
//  Created by Ho Pin Xian on 16/3/21.
//

import XCTest
@testable import paintsplash

class PaintGunTests: XCTestCase {

    func testLoad_loadThreeAmmo() {
        let paintgun = PaintGun()
        paintgun.load(AmmoHelper.red)
        paintgun.load(AmmoHelper.blue)
        paintgun.load(AmmoHelper.blue)
        
        XCTAssertEqual(paintgun.shoot()?.getColor(), PaintColor.blue)
        XCTAssertEqual(paintgun.shoot()?.getColor(), PaintColor.purple)
        XCTAssertEqual(paintgun.shoot()?.getColor(), PaintColor.purple)
        XCTAssertNil(paintgun.shoot()?.getColor())
    }
    
    func testLoad_loadOneAmmo() {
        let paintgun = PaintGun()
        paintgun.load(AmmoHelper.red)
        
        XCTAssertEqual(paintgun.shoot()?.getColor(), PaintColor.red)
        XCTAssertNil(paintgun.shoot()?.getColor())
    }
    
    func testLoad_loadMultipleAmmo() {
        let paintgun = PaintGun()
        paintgun.load([AmmoHelper.red, AmmoHelper.red, AmmoHelper.yellow, AmmoHelper.blue, AmmoHelper.orange, AmmoHelper.white, AmmoHelper.purple, AmmoHelper.white])
        
        XCTAssertEqual(paintgun.shoot()?.getColor(), PaintColor.lightpurple)
        XCTAssertEqual(paintgun.shoot()?.getColor(), PaintColor.lightpurple)
        XCTAssertEqual(paintgun.shoot()?.getColor(), PaintColor.lightorange)
        XCTAssertEqual(paintgun.shoot()?.getColor(), PaintColor.lightorange)
        XCTAssertEqual(paintgun.shoot()?.getColor(), PaintColor.blue)
        XCTAssertEqual(paintgun.shoot()?.getColor(), PaintColor.orange)
        XCTAssertEqual(paintgun.shoot()?.getColor(), PaintColor.orange)
        XCTAssertEqual(paintgun.shoot()?.getColor(), PaintColor.red)
        XCTAssertNil(paintgun.shoot()?.getColor())
        
        paintgun.load([AmmoHelper.purple, AmmoHelper.orange, AmmoHelper.green, AmmoHelper.red, AmmoHelper.white])
        
        XCTAssertEqual(paintgun.shoot()?.getColor(), PaintColor.lightred)
        XCTAssertEqual(paintgun.shoot()?.getColor(), PaintColor.lightred)
        XCTAssertEqual(paintgun.shoot()?.getColor(), PaintColor.green)
        XCTAssertEqual(paintgun.shoot()?.getColor(), PaintColor.orange)
        XCTAssertEqual(paintgun.shoot()?.getColor(), PaintColor.purple)
        XCTAssertNil(paintgun.shoot()?.getColor())
    }
}

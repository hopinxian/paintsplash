//
//  MultiWeaponComponentTests.swift
//  paintsplashTests
//
//  Created by admin on 3/4/21.
//

import XCTest
@testable import paintsplash

class MultiWeaponComponentTests: XCTestCase {

    var component: MultiWeaponComponent!
    var activeWeapon: PaintGun!
    let ammoA = PaintAmmo(color: .red)
    let ammoB = PaintAmmo(color: .orange)

    override func setUp() {
        super.setUp()
        activeWeapon = PaintGun()
        component = MultiWeaponComponent(weapons: [activeWeapon, Bucket()])
    }

    func testConstruct() throws {
        XCTAssertTrue(component.active)
        XCTAssertEqual(component.capacity, 4)
        XCTAssertTrue(component.activeWeapon is PaintGun)
        XCTAssertEqual(component.availableWeapons.count, 2)
    }

    func testLoad() {
        component.load([ammoA, ammoB])
        if let ammos = activeWeapon.getAmmo() as? [PaintAmmo] {
            XCTAssertEqual(ammos, [ammoA, ammoB])
        } else {
            XCTFail("Ammo should be paintammo")
        }

        component.load(to: Bucket.self, ammo: [ammoA, ammoB])
        let actualAmmos = component.availableWeapons[1].getAmmo()
        if let ammos = actualAmmos as? [PaintAmmo] {
            XCTAssertEqual(ammos, [ammoA, ammoB])
        } else {
            XCTFail("Ammo should be paintammo")
        }
    }

    func testShoot() {
        var projectile = component.shoot(from: Vector2D.zero, in: Vector2D.zero)
        XCTAssertNil(projectile)

        component.load([ammoA])
        projectile = component.shoot(from: Vector2D.zero, in: Vector2D.zero)
        XCTAssertTrue(projectile is PaintProjectile)
        XCTAssertEqual((projectile as? PaintProjectile)?.color, .red)
    }

    func testSwitchWeapon() {
        var weapon = component.switchWeapon(to: Bucket.self)
        XCTAssertTrue(component.activeWeapon is Bucket)
        XCTAssertTrue(weapon is Bucket)

        weapon = component.switchWeapon(to: PaintGun.self)
        XCTAssertTrue(component.activeWeapon is PaintGun)
        XCTAssertTrue(weapon is PaintGun)
    }

    func testCanShoot() {
        XCTAssertFalse(component.canShoot())
        component.load([ammoA])

        XCTAssertTrue(component.canShoot())
        _ = component.shoot(from: Vector2D.zero, in: Vector2D.zero)
        XCTAssertFalse(component.canShoot())
    }

    func testCanLoad() {
        XCTAssertTrue(component.canLoad([ammoA]))
        component.load([ammoA, ammoB, ammoA, ammoB])
        XCTAssertFalse(component.canLoad([ammoB]))
        _ = component.shoot(from: Vector2D.zero, in: Vector2D.zero)
        XCTAssertTrue(component.canLoad([ammoA]))
    }

    func testGetAmmo() {
        var ammos: [Ammo] = component.getAmmo()
        XCTAssertTrue(ammos.isEmpty)

        component.load([ammoA])
        ammos = component.getAmmo()
        XCTAssertEqual(ammos[0] as? PaintAmmo, ammoA)

        component.load(to: Bucket.self, ammo: [ammoB])
        let ammoList: [(Weapon, [Ammo])] = component.getAmmo()
        XCTAssertTrue(ammoList[0].0 is PaintGun)
        XCTAssertEqual(ammoList[0].1[0] as? PaintAmmo, ammoA)
        XCTAssertTrue(ammoList[1].0 is Bucket)
        XCTAssertEqual(ammoList[1].1[0] as? PaintAmmo, ammoB)
    }

}

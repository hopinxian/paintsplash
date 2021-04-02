//
//  PlayerWeaponChangeTests.swift
//  paintsplashTests
//
//  Created by Praveen Bala on 21/3/21.
//

import XCTest
@testable import paintsplash

class PlayerWeaponChangeTests: XCTestCase {

    var player: Player!

    override func setUp() {
        super.setUp()
        player = Player(initialPosition: Vector2D.zero)
    }

    private func changeToBucket() {
        let event = PlayerChangeWeaponEvent(newWeapon: Bucket.self, playerId: player.id)
        player.onWeaponChange(event: event)
        checkIfBucket()
    }

    private func changeToPaintGun() {
        let event = PlayerChangeWeaponEvent(newWeapon: PaintGun.self, playerId: player.id)
        player.onWeaponChange(event: event)
        checkIfPaintGun()
    }

    private func checkIfBucket() {
        XCTAssertTrue(player.multiWeaponComponent.activeWeapon is Bucket)
    }

    private func checkIfPaintGun() {
        XCTAssertTrue(player.multiWeaponComponent.activeWeapon is PaintGun)
    }

    func testWeaponChange() {
        // Change weapon to paintgun
        changeToPaintGun()
        checkIfPaintGun()

        // Change weapon from paintgun to paintgun. Should still be a paintgun
        changeToPaintGun()
        checkIfPaintGun()

        // Change weapon to bucket
        changeToBucket()
        checkIfBucket()

        // Change weapon from bucket to bucket. Should still be a bucket.
        changeToBucket()
        checkIfBucket()
    }
}

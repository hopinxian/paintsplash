//
//  LevelSpawnEventTests.swift
//  paintsplashTests
//
//  Created by Ho Pin Xian on 21/3/21.
//

import XCTest
@testable import paintsplash

class LevelSpawnEventTests: XCTestCase {

    let spawnObjectA = LevelSpawnType.enemy(location: nil, color: nil)
    let spawnObjectB = LevelSpawnType.enemySpawner(location: nil, color: nil)

    func testConstruct() {
        let event = LevelSpawnEvent(time: 2, spawnObject: spawnObjectA)
        XCTAssertEqual(event.time, 2)
        XCTAssertEqual(event.spawnObject, spawnObjectA)
    }

    func testEqual() {
        let eventA = LevelSpawnEvent(time: 2, spawnObject: spawnObjectA)
        let eventB = LevelSpawnEvent(time: 2, spawnObject: spawnObjectB)
        XCTAssertNotEqual(eventA, eventB)

        let eventC = LevelSpawnEvent(time: 3, spawnObject: spawnObjectA)
        XCTAssertNotEqual(eventA, eventC)

        let eventACopy = LevelSpawnEvent(time: 2, spawnObject: spawnObjectA)
        XCTAssertEqual(eventA, eventACopy)
    }

    func testCompare() {
        let eventA = LevelSpawnEvent(time: 2, spawnObject: spawnObjectA)
        let eventB = LevelSpawnEvent(time: 2, spawnObject: spawnObjectB)
        XCTAssertFalse(eventA < eventB)
        XCTAssertFalse(eventB < eventA)

        let eventC = LevelSpawnEvent(time: 3, spawnObject: spawnObjectA)
        XCTAssertTrue(eventA < eventC)
        XCTAssertFalse(eventA > eventC)
    }
}

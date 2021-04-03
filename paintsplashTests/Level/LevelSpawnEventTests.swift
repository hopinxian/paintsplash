//
//  LevelSpawnEventTests.swift
//  paintsplashTests
//
//  Created by Ho Pin Xian on 21/3/21.
//

import XCTest
@testable import paintsplash

class LevelSpawnEventTests: XCTestCase {

    let spawnObjectA = EnemyCommand()
    let spawnObjectB = EnemySpawnerCommand()

    func testConstruct() {
        let event = EnemyCommand()
        event.time = 2
        XCTAssertEqual(event.time, 2)
        XCTAssertEqual(event.color, nil)
        XCTAssertEqual(event.location, nil)
    }

    func testEqual() {
        let eventA = EnemyCommand()
        eventA.time = 2
        let eventB = EnemySpawnerCommand()
        eventB.time = 2
        XCTAssertNotEqual(eventA, eventB)

        let eventC = EnemyCommand()
        eventC.time = 3
        XCTAssertNotEqual(eventA, eventC)

        let eventACopy = EnemyCommand()
        eventACopy.time = 2
        XCTAssertEqual(eventA.color, eventACopy.color)
        XCTAssertEqual(eventA.location, eventACopy.location)
        XCTAssertEqual(eventA.time, eventACopy.time)

    }

    func testCompare() {
        let eventA = EnemyCommand()
        eventA.time = 2
        let eventB = EnemySpawnerCommand()
        eventB.time = 2
        XCTAssertFalse(eventA < eventB)
        XCTAssertFalse(eventB < eventA)

        let eventC = EnemyCommand()
        eventC.time = 3
        XCTAssertTrue(eventA < eventC)
        XCTAssertFalse(eventA > eventC)
    }
}

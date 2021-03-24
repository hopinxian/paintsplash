//
//  LevelTests.swift
//  paintsplashTests
//
//  Created by Ho Pin Xian on 20/3/21.
//

import XCTest
@testable import paintsplash

class LevelTests: XCTestCase {

    let gameManager = GameManager(renderSystem: MockRenderSystem(), collisionSystem: MockCollisionSystem())
    let canvasRequestManager = CanvasRequestManager()

    let enemyEvent = LevelSpawnEvent(time: 2, spawnObject: LevelSpawnType.enemy(location: nil, color: nil))
    let enemySpawnerEvent = LevelSpawnEvent(time: 3,
                                            spawnObject: LevelSpawnType.enemySpawner(location: nil, color: nil))
    let ammoDropEvent = LevelSpawnEvent(time: 4,
                                        spawnObject: LevelSpawnType.ammoDrop(location: nil, color: nil))
    let canvasSpawner = LevelSpawnType.canvasSpawner(location: nil, velocity: nil,
                                                     canvasSize: nil, spawnInterval: nil, endX: 10)

    var canvasSpawnerEvent: LevelSpawnEvent {
        LevelSpawnEvent(time: 5, spawnObject: canvasSpawner)
    }

    func testConstruct() {
        let level = Level(gameManager: gameManager, canvasManager: canvasRequestManager)
        XCTAssertEqual(level.bufferBetweenLoop, 5.0)
        XCTAssertNil(level.repeatLimit)
        XCTAssertEqual(level.canvasSpawnInterval, 2.0)
        XCTAssertFalse(level.isRunning)
        XCTAssertEqual(level.score.score, 0)
        XCTAssertEqual(level.spawnEvents.count, 0)
    }

    func testGetRandomRequest() {
        let level = Level(gameManager: gameManager, canvasManager: canvasRequestManager)
        for _ in 1...20 {
            let request: Set<PaintColor> = level.getRandomRequest()
            XCTAssertLessThan(request.count, 5)
            XCTAssertNotEqual(request.count, 0)
        }
    }

    func testStop() {
        let level = Level(gameManager: gameManager, canvasManager: canvasRequestManager)
        level.run()
        level.stop()
        XCTAssertFalse(level.isRunning)
        XCTAssertTrue(level.score.freeze)
    }

    func testContinueSpawn() {
        let level = Level(gameManager: gameManager, canvasManager: canvasRequestManager)
        level.run()
        level.stop()
        level.continueSpawn()
        XCTAssertTrue(level.isRunning)
        XCTAssertFalse(level.score.freeze)
    }

    func testAddSpawnEvent_singleEvent() {
        let level = Level(gameManager: gameManager, canvasManager: canvasRequestManager)
        level.addSpawnEvent(enemyEvent)
        XCTAssertEqual(level.spawnEvents, [enemyEvent])

        level.addSpawnEvent(enemySpawnerEvent)
        XCTAssertEqual(level.spawnEvents, [enemyEvent, enemySpawnerEvent])
    }

    func testAddSpawnEvent_differentEvents() {
        let level = Level(gameManager: gameManager, canvasManager: canvasRequestManager)
        let events = [enemyEvent, enemySpawnerEvent, ammoDropEvent, canvasSpawnerEvent]

        for event in events {
            level.addSpawnEvent(event)
        }

        XCTAssertEqual(level.spawnEvents, events)
    }

    func testRemoveSpawnEvent() {
        let level = Level(gameManager: gameManager, canvasManager: canvasRequestManager)
        level.addSpawnEvent(enemyEvent)
        level.addSpawnEvent(enemySpawnerEvent)
        level.addSpawnEvent(enemyEvent)
        XCTAssertEqual(level.spawnEvents, [enemyEvent, enemySpawnerEvent, enemyEvent])

        level.removeSpawnEvent(enemyEvent)
        XCTAssertEqual(level.spawnEvents, [enemySpawnerEvent, enemyEvent])

        level.removeSpawnEvent(enemyEvent)
        XCTAssertEqual(level.spawnEvents, [enemySpawnerEvent])

        level.removeSpawnEvent(enemyEvent)
        XCTAssertEqual(level.spawnEvents, [enemySpawnerEvent])

        level.removeSpawnEvent(enemySpawnerEvent)
        XCTAssertEqual(level.spawnEvents, [])

        level.removeSpawnEvent(enemySpawnerEvent)
        XCTAssertEqual(level.spawnEvents, [])
    }

    func testClearAll() {
        let level = Level(gameManager: gameManager, canvasManager: canvasRequestManager)
        level.addSpawnEvent(enemyEvent)
        level.addSpawnEvent(enemySpawnerEvent)

        level.clearAll()
        XCTAssertEqual(level.spawnEvents, [])

        level.clearAll()
        XCTAssertEqual(level.spawnEvents, [])
    }

    func addSpawnEvent_multipleEventsAtOnce() {
        let level = Level(gameManager: gameManager, canvasManager: canvasRequestManager)

        level.addSpawnEvent(enemyEvent, times: 10)
        let expectedEvents = [LevelSpawnEvent](repeating: enemyEvent, count: 10)

        XCTAssertEqual(level.spawnEvents, expectedEvents)
    }
}

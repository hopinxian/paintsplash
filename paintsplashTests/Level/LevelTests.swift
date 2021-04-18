//
//  LevelTests.swift
//  paintsplashTests
//
//  Created by Ho Pin Xian on 20/3/21.
//

import XCTest
@testable import paintsplash

class LevelTests: XCTestCase {

    let canvasRequestManager = CanvasRequestManager()
    var level: Level!

    var enemyEvent: EnemyCommand!
    var enemySpawnerEvent: EnemySpawnerCommand!
    var ammoDropEvent: AmmoDropCommand!

    override func setUp() {
        super.setUp()

        level = Level(canvasManager: canvasRequestManager,
                      gameInfo: GameInfo(playerPosition: Vector2D.zero))

        enemyEvent = EnemyCommand()
        enemyEvent.time = 2

        enemySpawnerEvent = EnemySpawnerCommand()
        enemySpawnerEvent.time = 3

        ammoDropEvent = AmmoDropCommand()
        ammoDropEvent.time = 4
    }

    func testConstruct() {
        XCTAssertEqual(level.bufferBetweenLoop, 5.0)
        XCTAssertNil(level.repeatLimit)
        XCTAssertFalse(level.isRunning)
        XCTAssertEqual(level.score.score, 0)
        XCTAssertEqual(level.spawnCmd.count, 0)
    }

    func testGetRandomRequest() {
        for _ in 1...20 {
            let request: Set<PaintColor> = SpawnCommand().getRandomRequest()
            XCTAssertLessThan(request.count, 5)
            XCTAssertNotEqual(request.count, 0)
        }
    }

    func testStop() {
        level.start()
        level.stop()
        XCTAssertFalse(level.isRunning)
        XCTAssertTrue(level.score.freeze)
    }

    func testContinueSpawn() {
        level.start()
        level.stop()
        level.continueSpawn()
        XCTAssertTrue(level.isRunning)
        XCTAssertFalse(level.score.freeze)
    }

    func testAddSpawnEvent_singleEvent() {
        level.addCommand(enemyEvent)
        XCTAssertEqual(level.spawnCmd, [enemyEvent])

        level.addCommand(enemySpawnerEvent)
        XCTAssertEqual(level.spawnCmd, [enemyEvent, enemySpawnerEvent])
    }

    func testAddSpawnEvent_differentEvents() {
        let events: [SpawnCommand] = [enemyEvent, enemySpawnerEvent, ammoDropEvent]

        for event in events {
            level.addCommand(event)
        }

        XCTAssertEqual(level.spawnCmd, events)
    }

    func testRemoveSpawnEvent() {
        level.addCommand(enemyEvent)
        level.addCommand(enemySpawnerEvent)
        level.addCommand(enemyEvent)
        XCTAssertEqual(level.spawnCmd, [enemyEvent, enemySpawnerEvent, enemyEvent])

        level.removeCommand(enemyEvent)
        XCTAssertEqual(level.spawnCmd, [enemySpawnerEvent, enemyEvent])

        level.removeCommand(enemyEvent)
        XCTAssertEqual(level.spawnCmd, [enemySpawnerEvent])

        level.removeCommand(enemyEvent)
        XCTAssertEqual(level.spawnCmd, [enemySpawnerEvent])

        level.removeCommand(enemySpawnerEvent)
        XCTAssertEqual(level.spawnCmd, [])

        level.removeCommand(enemySpawnerEvent)
        XCTAssertEqual(level.spawnCmd, [])
    }

    func testClearAll() {
        level.addCommand(enemyEvent)
        level.addCommand(enemySpawnerEvent)

        level.clearCommands()
        XCTAssertEqual(level.spawnCmd, [])

        level.clearCommands()
        XCTAssertEqual(level.spawnCmd, [])
    }
}

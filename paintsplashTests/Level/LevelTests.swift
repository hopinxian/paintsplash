//
//  LevelTests.swift
//  paintsplashTests
//
//  Created by Ho Pin Xian on 20/3/21.
//

import XCTest
@testable import paintsplash

class LevelTests: XCTestCase {

    var gameManager: GameManager!
    let canvasRequestManager = CanvasRequestManager()
    var level: Level!

    var enemyEvent: EnemyCommand!
    var enemySpawnerEvent: EnemySpawnerCommand!
    var ammoDropEvent: AmmoDropCommand!
    var canvasSpawnerEvent: CanvasSpawnerCommand!

    override func setUp() {
        super.setUp()
        let gameManager = SinglePlayerGameManager(gameScene: GameScene())
        gameManager.renderSystem = MockRenderSystem()
        gameManager.collisionSystem = MockCollisionSystem()
        self.gameManager = gameManager
<<<<<<< HEAD
        
        level = Level(gameManager: gameManager, canvasManager: canvasRequestManager,
                      gameInfo: GameInfo(playerPosition: Vector2D.zero, numberOfEnemies: 0))
        
=======

        level = Level(gameManager: gameManager,
                      canvasManager: canvasRequestManager,
                      gameInfo: GameInfo(playerPosition: Vector2D.zero, numberOfEnemies: 0)
        )

>>>>>>> 4ae491f023fdb636d324671a48cbd93ca6bfe8c3
        enemyEvent = EnemyCommand()
        enemyEvent.time = 2

        enemySpawnerEvent = EnemySpawnerCommand()
        enemySpawnerEvent.time = 3

        ammoDropEvent = AmmoDropCommand()
        ammoDropEvent.time = 4

        canvasSpawnerEvent = CanvasSpawnerCommand(endX: 10)
        canvasSpawnerEvent.time = 5
    }

    func testConstruct() {
        XCTAssertEqual(level.bufferBetweenLoop, 5.0)
        XCTAssertNil(level.repeatLimit)
        XCTAssertEqual(level.canvasSpawnInterval, 2.0)
        XCTAssertFalse(level.isRunning)
        XCTAssertEqual(level.score.score, 0)
        XCTAssertEqual(level.spawnEvents.count, 0)
    }

    func testGetRandomRequest() {
        for _ in 1...20 {
            let request: Set<PaintColor> = level.getRandomRequest()
            XCTAssertLessThan(request.count, 5)
            XCTAssertNotEqual(request.count, 0)
        }
    }

    func testStop() {
        level.run()
        level.stop()
        XCTAssertFalse(level.isRunning)
        XCTAssertTrue(level.score.freeze)
    }

    func testContinueSpawn() {
        level.run()
        level.stop()
        level.continueSpawn()
        XCTAssertTrue(level.isRunning)
        XCTAssertFalse(level.score.freeze)
    }

    func testAddSpawnEvent_singleEvent() {
        level.addSpawnEvent(enemyEvent)
        XCTAssertEqual(level.spawnEvents, [enemyEvent])

        level.addSpawnEvent(enemySpawnerEvent)
        XCTAssertEqual(level.spawnEvents, [enemyEvent, enemySpawnerEvent])
    }

    func testAddSpawnEvent_differentEvents() {
        let events: [SpawnCommand] = [enemyEvent, enemySpawnerEvent, ammoDropEvent, canvasSpawnerEvent]

        for event in events {
            level.addSpawnEvent(event)
        }

        XCTAssertEqual(level.spawnEvents, events)
    }

    func testRemoveSpawnEvent() {
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
        level.addSpawnEvent(enemyEvent)
        level.addSpawnEvent(enemySpawnerEvent)

        level.clearAll()
        XCTAssertEqual(level.spawnEvents, [])

        level.clearAll()
        XCTAssertEqual(level.spawnEvents, [])
    }

    func addSpawnEvent_multipleEventsAtOnce() {
        level.addSpawnEvent(enemyEvent, times: 10)
        let expectedEvents = [SpawnCommand](repeating: enemyEvent, count: 10)

        XCTAssertEqual(level.spawnEvents, expectedEvents)
    }
}

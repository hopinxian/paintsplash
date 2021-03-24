//
//  Level.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 18/3/21.
//

import UIKit
import Foundation

class Level {
    private(set) var spawnEvents: [LevelSpawnEvent] = []

    var repeatLimit: Int?
    var bufferBetweenLoop = 5.0 // in seconds
    private var gameManager: GameManager

    private var canvasRequestManager: CanvasRequestManager
    private(set) var canvasSpawnInterval = 2.0
    private(set) var lastSpawnDate: Date!

    /// Runtime information
    private(set) var isRunning: Bool = false
    private(set) var loopStartTime: Date!
    private(set) var nextSpawnEvent: Int = 0
    private(set) var currentLoop = 1
    private(set) var score: LevelScore

    private static let defaultInterval = 10.0
    private static let defaultCanvasSize = Vector2D(200, 200)

    let bounds = Constants.PLAYER_MOVEMENT_BOUNDS

    init(gameManager: GameManager, canvasManager: CanvasRequestManager) {
        self.gameManager = gameManager
        self.canvasRequestManager = canvasManager
        score = LevelScore(gameManager: gameManager)
    }

    func run() {
        if spawnEvents.isEmpty {
            return
        }
        score.reset()
        score.freeze = false
        isRunning = true
        spawnEvents.sort()
        currentLoop = 1
        nextSpawnEvent = 0
        loopStartTime = Date()
        lastSpawnDate = Date()
    }

    func update() {
        guard isRunning else {
            return
        }

        var timeSinceLoopStart = Date().timeIntervalSince(loopStartTime)
        while timeSinceLoopStart >= spawnEvents[nextSpawnEvent].time {
            execute(spawnEvents[nextSpawnEvent])
            nextSpawnEvent += 1
            if nextSpawnEvent == spawnEvents.count {
                currentLoop += 1
                nextSpawnEvent = 0
                if let limit = repeatLimit, currentLoop > limit {
                    isRunning = false
                    break
                }
                loopStartTime = Date() + bufferBetweenLoop
            }
            timeSinceLoopStart = Date().timeIntervalSince(loopStartTime)
        }

        let timeSinceLastRquest = Date().timeIntervalSince(lastSpawnDate)
        if timeSinceLastRquest >= canvasSpawnInterval {
            let request = getRandomRequest()
            canvasRequestManager.addRequest(colors: request)
            lastSpawnDate = Date()
        }
    }

    func getRandomRequest() -> Set<PaintColor> {
        let randomNumber = Int.random(in: 1..<4)
        let colors = PaintColor.allCases.shuffled().filter { $0 != PaintColor.white }
        var request = Set<PaintColor>()
        for index in 1...randomNumber {
            request.insert(colors[index])
        }
        return request
    }

    private func execute(_ spawnObject: LevelSpawnEvent) {
        switch spawnObject.spawnObject {
        case let .ammoDrop(location, color):
            spawnAmmoDrop(location: location, color: color)
        case let .canvasSpawner(location, velocity, canvasSize, spawnInterval, endX):
            spawnCanvasSpawner(location: location, velocity: velocity,
                               canvasSize: canvasSize, spawnInterval: spawnInterval, endX: endX)
        case let .enemy(location, color):
            spawnEnemy(location: location, color: color)
        case let .enemySpawner(location, color):
            spawnEnemySpawner(location: location, color: color)
        }
    }

    private func spawnAmmoDrop(location: Vector2D?, color: PaintColor?) {

        let eventLocation = getLocation(location: location)

        let ammoDrop = PaintAmmoDrop(color: getColor(color: color), position: eventLocation)
        ammoDrop.spawn()
    }

    private func spawnCanvasSpawner(location: Vector2D?, velocity: Vector2D?,
                                    canvasSize: Vector2D?, spawnInterval: Double?, endX: Double) {

        let eventLocation = getLocation(location: location)
        let eventVelocity = getVelocity(velocity: velocity)
        let eventCanvasSize = getCanvasSize(size: canvasSize)
        let eventSpawnInterval = getSpawnInterval(interval: spawnInterval)

        let event = SpawnAIEntityEvent(spawnEntityType: .canvasSpawner(
            location: eventLocation,
            velocity: eventVelocity, size: eventCanvasSize,
            spawnInterval: eventSpawnInterval,
            endX: endX)
        )
        EventSystem.spawnAIEntityEvent.post(event: event)
    }

    private func spawnEnemy(location: Vector2D?, color: PaintColor?) {
        let eventLocation = getLocation(location: location)
        let eventColor = getColor(color: color)

        let enemy = Enemy(initialPosition: eventLocation, color: eventColor)
        enemy.spawn()
    }

    private func spawnEnemySpawner(location: Vector2D?, color: PaintColor?) {
        let eventLocation = getLocation(location: location)
        let eventColor = getColor(color: color)

        let enemySpawner = EnemySpawner(initialPosition: eventLocation, color: eventColor)
        enemySpawner.spawn()
    }

    func stop() {
        isRunning = false
        score.freeze = true
    }

    func continueSpawn() {
        isRunning = true
        score.freeze = false
    }

    func addSpawnEvent(_ event: LevelSpawnEvent) {
        spawnEvents.append(event)
    }

    func removeSpawnEvent(_ event: LevelSpawnEvent) {
        if let index = spawnEvents.firstIndex(of: event) {
            spawnEvents.remove(at: index)
        }
    }

    func clearAll() {
        spawnEvents = []
    }

    /// enemies from the given level will start appearing after enemies from the current level is done
    func append(level: Level) {
        let delay = spawnEvents.map { $0.time }.max() ?? bufferBetweenLoop
        for event in level.spawnEvents {
            let delayedEvent = LevelSpawnEvent(time: event.time + delay, spawnObject: event.spawnObject)
            spawnEvents.append(delayedEvent)
        }
    }

    /// enemies from both levels are overlayed along the timeline
    func overlay(level: Level) {
        spawnEvents += level.spawnEvents
    }

    /// intended for mass appearance of identical enemies
    func addSpawnEvent(_ event: LevelSpawnEvent, times: Int) {
        for _ in 0..<times {
            addSpawnEvent(event)
        }
    }

    private func getLocation(location: Vector2D?) -> Vector2D {
        let randomX = Double.random(in: bounds.minX..<bounds.maxX)
        let randomY = Double.random(in: bounds.minY..<bounds.maxY)
        let location = location ?? Vector2D(randomX, randomY)
        return location
    }

    private func getColor(color: PaintColor?) -> PaintColor {
        let color = color ?? PaintColor.allCases.shuffled()[0]
        return color
    }

    private func getVelocity(velocity: Vector2D?) -> Vector2D {
        let velocity = velocity ?? Vector2D(0.2, 0)
        return velocity
    }

    private func getCanvasSize(size: Vector2D?) -> Vector2D {
        size ?? Self.defaultCanvasSize
    }

    private func getSpawnInterval(interval: Double?) -> Double {
        interval ?? Self.defaultInterval
    }

    static func getDefaultLevel(gameManager: GameManager, canvasManager: CanvasRequestManager) -> Level {
        let level = Level(gameManager: gameManager, canvasManager: canvasManager)
        let spawnObject = LevelSpawnType.enemy(location: nil, color: nil)

        let event = LevelSpawnEvent(time: 10, spawnObject: spawnObject)
        level.addSpawnEvent(event)

        let drop = LevelSpawnType.ammoDrop(location: nil, color: nil)
        let dropEvent = LevelSpawnEvent(time: 3, spawnObject: drop)

        let spawner = LevelSpawnType.enemySpawner(location: nil, color: nil)
        let spawnerEvent = LevelSpawnEvent(time: 15, spawnObject: spawner)

        level.addSpawnEvent(dropEvent)
        level.addSpawnEvent(spawnerEvent)

        return level
    }

}

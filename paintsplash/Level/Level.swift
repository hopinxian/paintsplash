//
//  Level.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 18/3/21.
//

import UIKit
import Foundation

class Level {
    private(set) var spawnEvents: [SpawnCommand] = []

    var rng = RandomNumber(100)

    var repeatLimit: Int?
    var bufferBetweenLoop = 5.0 // in seconds
    private var gameInfo: GameInfo

    static var enemyCapacity = 5
    static var dropCapacity = 5

    private var canvasRequestManager: CanvasRequestManager
    private(set) var canvasSpawnInterval = 2.0
    private(set) var lastSpawnDate: Date!

    /// Runtime information
    private(set) var isRunning = false
    private(set) var loopStartTime: Date!
    private(set) var nextSpawnEvent: Int = 0
    private(set) var currentLoop = 1
    private(set) var score: LevelScore

    static let defaultInterval = 10.0
    static let defaultCanvasSize = Vector2D(200, 200)

    let bounds = Constants.PLAYER_MOVEMENT_BOUNDS

    init(canvasManager: CanvasRequestManager, gameInfo: GameInfo) {
        self.canvasRequestManager = canvasManager
        self.gameInfo = gameInfo

        // TODO: comment out
        canvasRequestManager.addRequest(colors: [.yellow])

        score = LevelScore()
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
            spawnEvents[nextSpawnEvent].spawnIntoLevel(gameInfo: gameInfo)
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
        let randomNumber = rng.nextInt(1..<4)
        var request = Set<PaintColor>()
        let colors = PaintColor.allCases.filter {
            $0 != PaintColor.white
        }
        let length = colors.count
        for _ in 1...randomNumber {
            let randomColor = colors[rng.nextInt(0..<length)]
            request.insert(randomColor)
        }
        return request
    }

    func stop() {
        isRunning = false
        score.freeze = true
    }

    func continueSpawn() {
        isRunning = true
        score.freeze = false
    }

    func addSpawnEvent(_ event: SpawnCommand) {
        spawnEvents.append(event)
    }

    func removeSpawnEvent(_ event: SpawnCommand) {
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
            event.time += delay
            spawnEvents.append(event)
        }
    }

    /// enemies from both levels are overlayed along the timeline
    func overlay(level: Level) {
        spawnEvents += level.spawnEvents
    }

    /// intended for mass appearance of identical enemies
    func addSpawnEvent(_ event: SpawnCommand, times: Int) {
        for _ in 0..<times {
            addSpawnEvent(event)
        }
    }

    static func getDefaultLevel(canvasManager: CanvasRequestManager, gameInfo: GameInfo) -> Level {
        let path = "level"
        let level = LevelReader(filePath: path).readLevel(canvasManager: canvasManager, gameInfo: gameInfo)
        return level
    }
}

//
//  Level.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 18/3/21.
//

import UIKit
import Foundation

/**
 `Level` represents the set of events that happen during a level.
 A level consists of a number of `SpawnCommands` that it will perform
 when the event is running.
 A level can be configured to have limits on the number of enemies or drops
 on the scene, or to repeat itself for a set number of times.
 */
class Level {
    /// Sets a limit on the number of enemies and drops that can be on the screen
    static var enemyCapacity = 5
    static var dropCapacity = 5

    /// Represents the number of times the level repeats itself
    /// Nil when the level repeats infinitely
    var repeatLimit: Int?
    var bufferBetweenLoop = 5.0
    private var gameInfo: GameInfo
    private var requestManager: CanvasRequestManager
    private(set) var spawnCmd: [SpawnCommand] = []

    /// Information for when the level is running
    private(set) var isRunning = false
    private(set) var loopStartTime = Date()
    private(set) var nextCmdIndex = 0
    private(set) var currentLoop = 1
    private(set) var score: LevelScore

    init(canvasManager: CanvasRequestManager, gameInfo: GameInfo) {
        self.requestManager = canvasManager
        self.gameInfo = gameInfo
        score = LevelScore()
    }

    func start() {
        if spawnCmd.isEmpty {
            return
        }
        setUp()
        isRunning = true
    }

    /// Resets the level information for running
    func setUp() {
        score.reset()
        score.freeze = false
        spawnCmd.sort()
        currentLoop = 1
        nextCmdIndex = 0
        loopStartTime = Date()
    }

    /// Runs the level for the given amount of time.
    func run(_ deltaTime: Double) {
        guard isRunning else {
            return
        }

        // spawns all commands that should occur in the given time
        var timeSinceLoopStart = Date().timeIntervalSince(loopStartTime)
        while timeSinceLoopStart >= spawnCmd[nextCmdIndex].time {
            spawnCmd[nextCmdIndex].spawnIntoLevel(gameInfo: gameInfo)

            nextCmdIndex += 1
            if nextCmdIndex == spawnCmd.count { // one loop has completed
                moveToNextLoop()
                if let limit = repeatLimit,
                   currentLoop > limit {
                    // the game has finished running all loops
                    stop()
                    EventSystem.gameStateEvents.gameOverEvent.post(event: GameOverEvent(isWin: true))
                    break
                }
            }

            timeSinceLoopStart = Date().timeIntervalSince(loopStartTime)
        }
    }

    /// Updates the level information to shift to next loop when running
    private func moveToNextLoop() {
        currentLoop += 1
        nextCmdIndex = 0
        loopStartTime = Date() + bufferBetweenLoop
    }

    func stop() {
        isRunning = false
        score.freeze = true
    }

    func continueSpawn() {
        isRunning = true
        score.freeze = false
    }

    func addCommand(_ cmd: SpawnCommand) {
        if let request = cmd as? CanvasRequestCommand {
            request.requestManager = requestManager
        }
        spawnCmd.append(cmd)
    }

    func removeCommand(_ cmd: SpawnCommand) {
        if let index = spawnCmd.firstIndex(of: cmd) {
            spawnCmd.remove(at: index)
        }
    }

    func clearCommands() {
        spawnCmd = []
    }

    /// Commands from the given level will appear after commands from the current level is done
    func append(level: Level) {
        // delay is the time needed for one loop of this level to be completed
        let delay = spawnCmd.map { $0.time }.max() ?? 0
        for event in level.spawnCmd {
            event.time += delay
            spawnCmd.append(event)
        }
    }

    /// Commands from both levels are overlayed along the same timeline
    func overlay(level: Level) {
        spawnCmd += level.spawnCmd
    }

    static func getDefaultLevel(canvasManager: CanvasRequestManager, gameInfo: GameInfo) -> Level {
        let path = "Level"
        let level = LevelReader(filePath: path)
            .readLevel(canvasManager: canvasManager, gameInfo: gameInfo)
        return level
    }
}

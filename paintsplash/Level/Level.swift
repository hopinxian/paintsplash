//
//  Level.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 18/3/21.
//

import UIKit
import Foundation

class Level {
    var spawnEvents: [LevelSpawnEvent] = []
    
    var repeatLimit: Int?
    var bufferBetweenLoop = 5.0 // in seconds
    var gameManager: GameManager
    
    /// Runtime information
    var isRunning: Bool = false
    var loopStartTime: Date!
    var nextSpawnEvent: Int = 0
    var currentLoop = 1
    var score = LevelScore()

    private static let maxX: Double = Double(UIScreen.main.bounds.width / 3)
    private static let maxY: Double = Double(UIScreen.main.bounds.height / 3)
    
    init(gameManager: GameManager) {
        self.gameManager = gameManager
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
    }
        
    func update() {
        guard isRunning else {
            return
        }
        
        var timeSinceLoopStart = Date().timeIntervalSince(loopStartTime)
        while (timeSinceLoopStart >= spawnEvents[nextSpawnEvent].time) {
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
    }
        
    func execute(_ spawnObject: LevelSpawnEvent) {
        switch spawnObject.spawnObject {
        case .ammoDrop(let location, let color):
            let ammoDrop = PaintAmmoDrop(color: getColor(color: color), position: getLocation(location: location))
            ammoDrop.spawn(gameManager: gameManager)
        case .canvasSpawner(let location, let velocity):
            let event = SpawnAIEntityEvent(spawnEntityType: .canvasSpawner(location: getLocation(location: location), velocity: getVelocity(velocity: velocity)))
            EventSystem.spawnAIEntityEvent.post(event: event)
        case .enemy(let location, let color):
            let event = SpawnAIEntityEvent(spawnEntityType: .enemy(location: getLocation(location: location), color: getColor(color: color)))
            EventSystem.spawnAIEntityEvent.post(event: event)
        case .enemySpawner(let location, let color):
            let event = SpawnAIEntityEvent(spawnEntityType: .enemySpawner(location: getLocation(location: location), color: getColor(color: color)))
            EventSystem.spawnAIEntityEvent.post(event: event)
        }
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
        let delay = spawnEvents.map{$0.time}.max() ?? bufferBetweenLoop
        for event in level.spawnEvents {
            let delayedEvent = LevelSpawnEvent(time: event.time + delay, spawnObject: event.spawnObject)
            spawnEvents.append(delayedEvent)
        }
    }
    
    /// enemies from both levels are overlayed along the timeline
    func overlay(level: Level) {
        spawnEvents = spawnEvents + level.spawnEvents
    }
    
    /// intended for mass appearance of identical enemies
    func addSpawnEvent(_ event: LevelSpawnEvent, times: Int) {
        for _ in 0..<times {
            addSpawnEvent(event)
        }
    }
    
    func getLocation(location: Vector2D?) -> Vector2D {
        let randomX = Double.random(in: -Self.maxX..<Self.maxX)
        let randomY = Double.random(in: -Self.maxY..<Self.maxY)
        let location = location ?? Vector2D(randomX, randomY)
        return location
    }
    
    func getColor(color: PaintColor?) -> PaintColor {
        let color = color ?? PaintColor.allCases.shuffled()[0]
        return color
    }
    
    func getVelocity(velocity: Vector2D?) -> Vector2D {
        let velocity = velocity ?? Vector2D(0.2, 0)
        return velocity
    }
    
    static func getDefaultLevel(gameManager: GameManager) -> Level {
        let level = Level(gameManager: gameManager)
        let spawnObject = LevelSpawnType.enemy(location: nil, color: nil)
        let event = LevelSpawnEvent(time: 2, spawnObject: spawnObject)
        level.addSpawnEvent(event)
        let drop = LevelSpawnType.ammoDrop(location: nil, color: nil)
        let dropEvent = LevelSpawnEvent(time: 2, spawnObject: drop)
        level.addSpawnEvent(dropEvent)
        level.addSpawnEvent(dropEvent)
        return level
    }
}

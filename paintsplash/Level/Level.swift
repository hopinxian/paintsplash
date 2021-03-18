//
//  Level.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 18/3/21.
//

import Foundation

class Level {
    var spawnEvents: [LevelSpawnEvent] = []
    
    // add state info
    var repeatLimit: Int?
    //var difficultyLevel: Int = 1
    //var difficultyScaling: Double = 1
    var bufferBetweenLoop = 2.0 // in seconds
    
    /// Runtime information
    var isRunning: Bool = false
    var loopStartTime: Date!
    var nextSpawnEvent: Int = 0
    var currentLoop = 1
        
    func run() {
        if spawnEvents.isEmpty {
            return
        }
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
            let event = spawnEvents[nextSpawnEvent].constructEvent()
            EventSystem.spawnAIEntityEvent.post(event: event)
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
        
    func stop() {
        isRunning = false
    }
    
    func continueSpawn() {
        isRunning = true
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
            let delayedEvent = LevelSpawnEvent(time: event.time + delay, color: event.color, location: event.location)
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
    
    static var defaultLevel: Level {
        let level = Level()
        let event = LevelSpawnEvent(time: 2, color: nil, location: nil)
        level.addSpawnEvent(event)
        return level
    }
}

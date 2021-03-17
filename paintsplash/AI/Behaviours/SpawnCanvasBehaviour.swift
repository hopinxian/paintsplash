//
//  SpawnCanvasBehaviour.swift
//  paintsplash
//
//  Created by Cynthia Lee on 17/3/21.
//
import Foundation

class SpawnCanvasBehaviour: AIBehaviour {
    var spawnInterval: Double

    var lastSpawnDate: Date

    var canvasVelocity: Vector2D

    init(spawnInterval: Double, canvasVelocity: Vector2D) {
        self.spawnInterval = spawnInterval
        self.lastSpawnDate = Date()

        self.canvasVelocity = canvasVelocity
    }

    func updateAI(aiEntity: AIEntity, aiGameInfo: AIGameInfo) {
        let timeSinceLastSpawn = Date().timeIntervalSince(lastSpawnDate)

        guard timeSinceLastSpawn >= spawnInterval else {
            return
        }

        print(aiEntity.position)
        let spawnCanvasEvent = SpawnAIEntityEvent(spawnEntityType: .canvas(location: aiEntity.position,
                                                                           velocity: canvasVelocity))
        EventSystem.spawnAIEntityEvent.post(event: spawnCanvasEvent)
        self.lastSpawnDate = Date()
    }
}


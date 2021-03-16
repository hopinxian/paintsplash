//
//  SpawnEnemiesBehaviour.swift
//  paintsplash
//
//  Created by Cynthia Lee on 11/3/21.
//
import Foundation

class SpawnEnemiesBehaviour: AIBehaviour, Colorable {
    var spawnInterval: Double

    var spawnQuantity: Int

    var lastSpawnDate: Date
    
    var color: PaintColor

    init(spawnInterval: Double, spawnQuantity: Int, color: PaintColor) {
        self.spawnInterval = spawnInterval
        self.spawnQuantity = spawnQuantity
        self.color = color
        self.lastSpawnDate = Date()
    }

    func updateAI(aiEntity: AIEntity, aiGameInfo: AIGameInfo) {
        let timeSinceLastSpawn = Date().timeIntervalSince(lastSpawnDate)

        guard timeSinceLastSpawn >= spawnInterval,
              let aiSystem = aiGameInfo.aiSystem else {
            return
        }

        let spawnPosition = aiEntity.position

         aiEntity.state = .spawning
         Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(resetSpawnState), userInfo: aiEntity, repeats: false)

        let subColors = color.getSubColors()
        for _ in 0..<spawnQuantity {
            guard let randomColor = subColors.randomElement() else {
                fatalError("Subcolors array should not be empty.")
            }
            let enemy = Enemy(initialPosition: spawnPosition, initialVelocity: Vector2D(-1, 0), color: randomColor)
            aiSystem.add(aiEntity: enemy)
        }

        self.lastSpawnDate = Date()
    }

    @objc func resetSpawnState(timer: Timer) {
        guard let entity = timer.userInfo as? AIEntity,
              entity.state != .hit else {
            return
        }
        entity.state = .idle
    }
}

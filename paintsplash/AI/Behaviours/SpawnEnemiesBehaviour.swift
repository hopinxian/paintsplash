//
//  SpawnEnemiesBehaviour.swift
//  paintsplash
//
//  Created by Cynthia Lee on 11/3/21.
//
import Foundation

class SpawnEnemiesBehaviour: AIBehaviour {
    var spawnInterval: Double

    var spawnQuantity: Int

    var lastSpawnDate: Date

    init(spawnInterval: Double, spawnQuantity: Int) {
        self.spawnInterval = spawnInterval
        self.spawnQuantity = spawnQuantity

        self.lastSpawnDate = Date()
    }

    func updateAI(aiEntity: AIEntity, aiGameInfo: AIGameInfo) {
        let timeSinceLastSpawn = Date().timeIntervalSince(lastSpawnDate)

        guard timeSinceLastSpawn >= spawnInterval else {
            return
        }

        aiEntity.state = .spawning
        Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(spawnEnemy),
                              userInfo: aiEntity, repeats: false)

        self.lastSpawnDate = Date()

//        guard let aiSystem = aiGameInfo.aiSystem else {
//            return
//        }
//
//        let enemy = Enemy(initialPosition: aiEntity.position, initialVelocity: Vector2D(-1, 0))
//        aiSystem.add(aiEntity: enemy)

    }

    @objc func spawnEnemy(timer: Timer) {
        guard let entity = timer.userInfo as? AIEntity,
              entity.state != .hit else {
            return
        }

        let spawnPosition = entity.position
        print("spawn position:", spawnPosition)

        for _ in 0..<spawnQuantity {
            let spawnEnemyEvent = SpawnAIEntityEvent(spawnEntityType: .enemy(location: spawnPosition))
            EventSystem.spawnAIEntityEvent.post(event: spawnEnemyEvent)
        }

        entity.state = .idle
    }
}

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
    
    var sourceColor: PaintColor

    init(spawnInterval: Double, spawnQuantity: Int, source: PaintColor) {
        self.spawnInterval = spawnInterval
        self.spawnQuantity = spawnQuantity
        self.sourceColor = source
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
    }

    @objc func spawnEnemy(timer: Timer) {
        guard let entity = timer.userInfo as? AIEntity,
              entity.state != .hit else {
            return
        }

        let spawnPosition = entity.position

        let subColors = sourceColor.getSubColors()
        for _ in 0..<spawnQuantity {
            guard let randomColor = subColors.randomElement() else {
                fatalError("Subcolors should never be empty.")
            }
            let spawnEntityEvent = SpawnAIEntityEvent(spawnEntityType: .enemy(location: spawnPosition, color: randomColor))
            EventSystem.spawnAIEntityEvent.post(event: spawnEntityEvent)
        }

        entity.state = .idle
    }
}

//
//  GameManagerAISystem.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//

class GameManagerAISystem: AISystem {
    var AIEntities: Set<AIEntity> = []

    var gameManager: GameManager

    init(gameManager: GameManager) {
        self.gameManager = gameManager
    }

    func updateAIEntities(aiGameInfo: AIGameInfo) {

    }

    func add(aiEntity: AIEntity) {
        self.AIEntities.insert(aiEntity)

        aiEntity.spawn(gameManager: gameManager)
    }

    func remove(aiEntity: AIEntity) {

    }

    func update(aiEntity: AIEntity) {
        
    }

    func addEnemy(at position: Vector2D) {
        let enemy = Enemy(initialPosition: Vector2D(50, 50), initialVelocity: Vector2D(-1, 0))
        self.add(aiEntity: enemy)
    }

}

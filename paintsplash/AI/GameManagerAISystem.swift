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
        aiEntity.delegate = self
    }

    func remove(aiEntity: AIEntity) {
        // TODO: set fade duration
        aiEntity.fadeDestroy(gameManager: gameManager, duration: 1.0)
    }

    func update(aiEntity: AIEntity) {
        
    }

    func addEnemy(at position: Vector2D) {
        let enemy = Enemy(initialPosition: Vector2D(50, 50), initialVelocity: Vector2D(-1, 0))
        self.add(aiEntity: enemy)
    }

}

extension GameManagerAISystem: AIEntityDelegate {
    func didEntityMove(aiEntity: AIEntity) {
        print("entity moved")
    }

    func didEntityUpdateState(aiEntity: AIEntity) {
        aiEntity.currentAnimation = aiEntity.getAnimationFromState()
        gameManager.getRenderSystem().updateRenderableAnimation(aiEntity)
    }

}

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

    func updateAIEntities() {
        AIEntities.forEach { entity in
            entity.currentBehaviour.updateAI(aiEntity: entity,
                                             aiGameInfo: AIGameInfo(playerPosition: gameManager.currentPlayerPosition,
                                                                    numberOfEnemies: AIEntities.count,
                                                                    aiSystem: self))
        }
    }

    func add(aiEntity: AIEntity) {
        self.AIEntities.insert(aiEntity)

        aiEntity.spawn(gameManager: gameManager)
        aiEntity.delegate = self

        aiEntity.delegate?.didEntityUpdateState(aiEntity: aiEntity)
    }

    func remove(aiEntity: AIEntity) {
        // TODO: set fade duration
        aiEntity.fadeDestroy(gameManager: gameManager, duration: 1.0)
    }

    func update(aiEntity: AIEntity) {
        
    }

    func addEnemy(at position: Vector2D, with color: PaintColor) {
        let enemy = Enemy(initialPosition: Vector2D(50, 50), initialVelocity: Vector2D(-1, 0), color: color)
        self.add(aiEntity: enemy)
    }

    func addEnemySpawner(at position: Vector2D, with color: PaintColor) {
        let enemySpawner = EnemySpawner(initialPosition: position, initialVelocity: .zero, color: color)
        self.add(aiEntity: enemySpawner)
    }

}

extension GameManagerAISystem: AIEntityDelegate {
    func didEntityMove(aiEntity: AIEntity) {
        //TODO
    }

    func didEntityUpdateState(aiEntity: AIEntity) {
        aiEntity.currentAnimation = aiEntity.getAnimationFromState()
        gameManager.getRenderSystem().updateRenderableAnimation(aiEntity)
    }

}

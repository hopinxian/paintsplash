//
//  GameManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 13/3/21.
//

class GameManager {
    var gameScene: GameScene
    var entities = Set<GameEntity>()
    var currentPlayerPosition = Vector2D(200, 200)

    var aiSystem: GameManagerAISystem?

    init(gameScene: GameScene) {
        self.gameScene = gameScene

        self.aiSystem = GameManagerAISystem(gameManager: self)

        self.aiSystem?.addEnemy(at: Vector2D(50, 50))
    }

    func getRenderSystem() -> RenderSystem {
        gameScene
    }

    func getCollisionSystem() -> CollisionSystem {
        gameScene
    }

    func getEnemies() -> [Enemy] {
        entities.compactMap({ $0 as? Enemy })
    }

    func removeAIEntity(aiEntity: AIEntity) {
        aiSystem?.remove(aiEntity: aiEntity)
    }

    func addObject(_ object: GameEntity) {
        entities.insert(object)
    }

    func removeObject(_ object: GameEntity) {
        entities.remove(object)
    }

    func update() {
        for entity in entities {
            entity.update(gameManager: self)
        }

        aiSystem?.updateAIEntities(aiGameInfo: AIGameInfo(playerPosition: currentPlayerPosition,
                                                          numberOfEnemies: 1))
    }
}

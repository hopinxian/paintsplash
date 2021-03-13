//
//  GameManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 13/3/21.
//

class GameManager {
    var gameScene: GameScene
    var entities = Set<GameEntity>()

    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }

    func getRenderSystem() -> RenderSystem {
        gameScene
    }

    func getCollisionSystem() -> CollisionSystem {
        gameScene
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
    }
}

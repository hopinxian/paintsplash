//
//  EnemySpawner.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//

class EnemySpawner: AIEntity {
    init(initialPosition: Vector2D, initialVelocity: Vector2D) {
        super.init(initialPosition: initialPosition, initialVelocity: initialVelocity, radius: 50)
        self.currentBehaviour = SpawnEnemiesBehaviour(spawnInterval: 3, spawnQuantity: 1)

        self.defaultSpeed = 0
    }

    override func getAnimationFromState() -> Animation {
        switch self.state {
        case .idle:
            return SpawnerAnimations.spawnerIdle
        case .spawning:
            return SpawnerAnimations.spawnerSpawn
        default:
            return SpawnerAnimations.spawnerIdle
        }
    }

    override func onCollide(otherObject: Collidable, gameManager: GameManager) {

    }

    override func update(gameManager: GameManager) {
//        updateAI(
//            aiGameInfo: AIGameInfo(
//                playerPosition: gameManager.currentPlayerPosition,
//                numberOfEnemies: gameManager.getEnemies().count
//            )
//        )

        super.update(gameManager: gameManager)
    }

}

//
//  EnemySpawner.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//

class EnemySpawner: AIEntity, Colorable {
    
    var color: PaintColor
    
    init(initialPosition: Vector2D, initialVelocity: Vector2D, color: PaintColor) {
        self.color = color
        let spriteName = "spawner" + "-" + color.rawValue
        super.init(spriteName: spriteName, initialPosition: initialPosition, initialVelocity: initialVelocity, radius: 50)
        self.currentBehaviour = SpawnEnemiesBehaviour(spawnInterval: 3, spawnQuantity: 1, source: color)
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
        guard otherObject.tags.contains(.playerProjectile) else {
            return
        }
        
        switch otherObject {
        case let projectile as PaintProjectile:
            if projectile.color != self.color {
                return
            }
        default:
            fatalError("Projectile not conforming to projectile protocol")
        }
        // TODO: response to being hit by a projectile of correct color
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

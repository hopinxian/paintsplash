//
//  EnemySpawner.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//

class EnemySpawner: AIEntity, Colorable, Health {
    
    var color: PaintColor

    var currentHealth: Int = 3
    var maxHealth: Int = 3
    
    init(initialPosition: Vector2D, initialVelocity: Vector2D, color: PaintColor) {
        self.color = color
        let spriteName = "Spawner"
        super.init(spriteName: spriteName, initialPosition: initialPosition, initialVelocity: initialVelocity, radius: 50, tags: [.enemy])
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

    override func onCollide(otherObject: Collidable) {
        if otherObject.tags.contains(.playerProjectile) {
            switch otherObject {
            case let projectile as PaintProjectile:
                if self.color.contains(color: projectile.color) {
                    takeDamage(amount: 1)
                }
            default:
                fatalError("Projectile not conforming to projectile protocol")
            }
        }
    }

    override func update(gameManager: GameManager) {
        super.update(gameManager: gameManager)
    }

    func heal(amount: Int) {
        currentHealth += amount

        if currentHealth > maxHealth {
            currentHealth = maxHealth
        }
    }

    func takeDamage(amount: Int) {
        currentHealth -=  amount

        if currentHealth <= 0 {
            currentHealth = 0
            die()

            return
        }

        self.state = .hit
    }

    private func die() {
        self.state = .die

        // gameManager.removeAIEntity(aiEntity: self)
        let event = DespawnAIEntityEvent(entityToDespawn: self)
        EventSystem.despawnAIEntityEvent.post(event: event)
    }


    override func destroy(gameManager: GameManager) {
        gameManager.removeObject(self)
        gameManager.getCollisionSystem().removeCollidable(self)
        animate(animation: SlimeAnimations.slimeDieGray, interupt: true) {
            gameManager.getRenderSystem().removeRenderable(self)
        }
    }

}

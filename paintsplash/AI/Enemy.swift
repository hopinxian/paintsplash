//
//  Enemy.swift
//  paintsplash
//
//  Created by Cynthia Lee on 11/3/21.
//

import SpriteKit

let hitDuration: Double = 0.25

class Enemy: AIEntity, Colorable, Health {
    var isHit: Bool = false

    var currentHealth: Int = 1
    var maxHealth: Int = 1

    var color: PaintColor
    
    init(initialPosition: Vector2D, initialVelocity: Vector2D, color: PaintColor) {
        self.color = color
        let spriteName = "Slime"
        super.init(spriteName: spriteName, initialPosition: initialPosition, initialVelocity: initialVelocity, radius: 50, tags: [.enemy])
        self.currentBehaviour = ApproachPointBehaviour()
        
        self.defaultSpeed = 1.0
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

        if otherObject.tags.contains(.player) {
            die()
        }

    }

    func setState() {
        if velocity.magnitude == 0 && self.state != .idle {
            self.state = .idle
            // currentAnimation = SlimeAnimations.slimeIdle
        } else if (velocity.x > 0) && self.state != .moveRight {
            self.state = .moveRight
            // currentAnimation = SlimeAnimations.slimeMoveRight
        } else if (velocity.x < 0) && self.state != .moveLeft{
            self.state = .moveLeft
            // currentAnimation = SlimeAnimations.slimeMoveLeft
        }
    }

    override func update(gameManager: GameManager) {
        // TODO: refactor?
        if self.state != .hit && self.state != .die {
            setState()
        }

        super.update(gameManager: gameManager)
    }

    override func getAnimationFromState() -> Animation {
        switch self.state {
        case .idle:
            return SlimeAnimations.slimeIdleGray
        case .moveLeft:
            return SlimeAnimations.slimeMoveLeftGray
        case .moveRight:
            return SlimeAnimations.slimeMoveRightGray
        case .hit:
            return SlimeAnimations.slimeHitGray
        case .afterHit:
            return SlimeAnimations.slimeHitGray
        case .die:
            return SlimeAnimations.slimeDieGray
        default:
            return SlimeAnimations.slimeIdleGray
        }
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
        EventSystem.scoreEvent.post(event: ScoreEvent(value: Points.enemyKill))
    }


    override func destroy(gameManager: GameManager) {
        gameManager.removeObject(self)
        gameManager.getCollisionSystem().removeCollidable(self)
        animate(animation: SlimeAnimations.slimeDieGray, interupt: true) {
            gameManager.getRenderSystem().removeRenderable(self)
        }
    }
}

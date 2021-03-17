//
//  Enemy.swift
//  paintsplash
//
//  Created by Cynthia Lee on 11/3/21.
//

import SpriteKit

let hitDuration: Double = 0.25

class Enemy: AIEntity, Colorable {

    var isHit: Bool = false

    var hitsToDie: Int = 1

    var color: PaintColor
    
    init(initialPosition: Vector2D, initialVelocity: Vector2D, color: PaintColor) {
        let spriteName = "slime" + "-" + color.rawValue
        self.color = color
        super.init(initialPosition: initialPosition, initialVelocity: initialVelocity, radius: 50)
        self.currentBehaviour = ApproachPointBehaviour()
        
        self.defaultSpeed = 1.0
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

        
        self.hitsToDie -= 1

        if self.hitsToDie <= 0 {
            self.state = .die

            // gameManager.removeAIEntity(aiEntity: self)
            let event = DespawnAIEntityEvent(entityToDespawn: self)
            EventSystem.despawnAIEntityEvent.post(event: event)

            return
        }

        self.state = .hit

        // TODO: set hit duration dynamically based on what it collided with?
        // TODO: change direction of hit animation?
        Timer.scheduledTimer(timeInterval: hitDuration, target: self, selector: #selector(resetHit),
                             userInfo: nil, repeats: false)
    }

    @objc func resetHit() {
        self.state = .afterHit
    }

    func setState() {
        if velocity.magnitude == 0 {
            self.state = .idle
            // currentAnimation = SlimeAnimations.slimeIdle
        } else if (velocity.x > 0) {
            self.state = .moveRight
            // currentAnimation = SlimeAnimations.slimeMoveRight
        } else if (velocity.x < 0) {
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
            return SlimeAnimations.slimeIdle
        case .moveLeft:
            return SlimeAnimations.slimeMoveLeft
        case .moveRight:
            return SlimeAnimations.slimeMoveRight
        case .hit:
            return SlimeAnimations.slimeHit
        case .afterHit:
            return SlimeAnimations.slimeHit
        case .die:
            return SlimeAnimations.slimeDie
        default:
            return SlimeAnimations.slimeIdle
        }
    }

}

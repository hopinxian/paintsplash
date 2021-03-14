//
//  Enemy.swift
//  paintsplash
//
//  Created by Cynthia Lee on 11/3/21.
//

import SpriteKit

class Enemy: AIEntity {

    var isHit: Bool = false

    init(initialPosition: Vector2D, initialVelocity: Vector2D) {
        super.init(initialPosition: initialPosition, initialVelocity: initialVelocity, radius: 50)
        self.currentBehaviour = ApproachPointBehaviour()
        
        self.currentAnimation = SlimeAnimations.slimeMoveRight

        self.defaultSpeed = 1.0
    }

    override func onCollide(otherObject: Collidable, gameManager: GameManager) {
        print("enemy hit")

        self.isHit = true

        // TODO: set hit duration dynamically?
        // TODO: change direction of hit animation?
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(resetHit),
                             userInfo: nil, repeats: false)
    }

    @objc func resetHit() {
        self.isHit = false
    }

    func setAnimation() {
        if self.isHit {
            currentAnimation = SlimeAnimations.slimeHit
            return
        }

        if velocity.magnitude == 0 {
            currentAnimation = SlimeAnimations.slimeIdle
        } else if (velocity.x > 0) {
            currentAnimation = SlimeAnimations.slimeMoveRight
        } else if (velocity.x < 0) {
            currentAnimation = SlimeAnimations.slimeMoveLeft
        }
    }

    override func update(gameManager: GameManager) {
        updateAI(
            aiGameInfo: AIGameInfo(
                playerPosition: gameManager.currentPlayerPosition,
                numberOfEnemies: gameManager.getEnemies().count
            )
        )

        setAnimation()

        super.update(gameManager: gameManager)
    }

}

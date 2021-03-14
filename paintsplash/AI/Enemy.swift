//
//  Enemy.swift
//  paintsplash
//
//  Created by Cynthia Lee on 11/3/21.
//

import SpriteKit

class Enemy: InteractiveEntity, AIEntity {
    var currentBehaviour: AIBehaviour

    var velocity: Vector2D

    var acceleration: Vector2D

    init(initialPosition: Vector2D, initialVelocity: Vector2D) {
        self.velocity = initialVelocity
        self.acceleration = Vector2D.zero

        self.currentBehaviour = ApproachPointBehaviour()

        var transform = Transform.identity
        transform.position = initialPosition

        super.init(spriteName: "", colliderShape: .circle(radius: 50), tags: .enemy, transform: transform)

        self.currentAnimation = SlimeAnimations.slimeMoveRight
    }

    override func onCollide(otherObject: Collidable, gameManager: GameManager) {
        print("enemy hit")
    }

    func changeBehaviour(to behaviour: AIBehaviour) {
        self.currentBehaviour = behaviour
    }

    func updateAI(aiGameInfo: AIGameInfo) {
        currentBehaviour.updateAI(aiEntity: self, aiGameInfo: aiGameInfo)
    }

    override func update(gameManager: GameManager) {
        updateAI(
            aiGameInfo: AIGameInfo(
                playerPosition: gameManager.currentPlayerPosition,
                numberOfEnemies: gameManager.getEnemies().count
            )
        )

        if (velocity.x >= 0) {
            currentAnimation = SlimeAnimations.slimeMoveRight
        } else if (velocity.x < 0) {
            currentAnimation = SlimeAnimations.slimeMoveLeft
        }

        super.update(gameManager: gameManager)
    }

}

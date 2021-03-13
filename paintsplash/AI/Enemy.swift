//
//  Enemy.swift
//  paintsplash
//
//  Created by Cynthia Lee on 11/3/21.
//

import SpriteKit

class Enemy: InteractiveEntity, AIEntity {
//    func buildNode() -> SKNode {
//        let enemyMoveAtlas = SKTextureAtlas(named: "SlimeMove")
//        var moveFrames: [SKTexture] = []
//
//        let numImages = enemyMoveAtlas.textureNames.count
//
//        for i in 1...numImages {
//            let enemyTexture = "slime-move-\(i).png"
//            moveFrames.append(enemyMoveAtlas.textureNamed(enemyTexture))
//        }
//
//        let enemySprite = SKSpriteNode(texture: moveFrames[0])
//
//        let animateAction = SKAction.repeatForever(SKAction.animate(with: moveFrames, timePerFrame: 0.2))
//        enemySprite.run(animateAction, completion: {
//            print("ran animation")
//        })
//
//        enemySprite.position = CGPoint(self.transform.position)
//        enemySprite.zRotation = CGFloat(self.transform.rotation)
//
//        // TODO: find a way for size to be determined dynamically
//        enemySprite.size = CGSize(width: 100, height: 100)
//
//        return enemySprite
//    }

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

        self.currentAnimation = SlimeAnimations.slimeMove
    }

    override func onCollide(otherObject: Collidable, gameManager: GameManager) {
        print("enemy hit")
    }

    func updateAI(aiGameInfo: AIGameInfo) {
        self.currentBehaviour.updateAI(aiEntity: self, aiGameInfo: aiGameInfo)
    }

    func changeBehaviour(to behaviour: AIBehaviour) {
        self.currentBehaviour = behaviour
    }

    override func update(gameManager: GameManager) {
        updateAI(aiGameInfo: AIGameInfo(playerPosition: gameManager.currentPlayerPosition,
                                        numberOfEnemies: gameManager.getEnemies().count))

        super.update(gameManager: gameManager)
    }

}

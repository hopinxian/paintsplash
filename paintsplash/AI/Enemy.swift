//
//  Enemy.swift
//  paintsplash
//
//  Created by Cynthia Lee on 11/3/21.
//

import SpriteKit

class Enemy: AIEntity, Renderable, Transformable, Movable, Collidable {
    var spriteMoveFrames: [SKTexture]?

    func buildNode() -> SKNode {
        let enemyMoveAtlas = SKTextureAtlas(named: "SlimeMove")
        var moveFrames: [SKTexture] = []

        let numImages = enemyMoveAtlas.textureNames.count

        for i in 0..<numImages {
            let enemyTexture = "slime-move-\(i).png"
            moveFrames.append(enemyMoveAtlas.textureNamed(enemyTexture))
        }

        self.spriteMoveFrames = moveFrames

        let enemySprite = SKSpriteNode(texture: moveFrames[0])

        let animateAction = SKAction.repeatForever(SKAction.animate(with: moveFrames, timePerFrame: 0.2))

        enemySprite.run(animateAction, completion: {
            print("ran animation")
        })

        enemySprite.position = CGPoint(self.transform.position)
        enemySprite.zRotation = CGFloat(self.transform.rotation)
        enemySprite.size = CGSize(width: 100, height: 100)

        return enemySprite
    }

    var currentBehaviour: AIBehaviour

    var velocity: Vector2D

    var acceleration: Vector2D

    var transform: Transform

    var spriteName: String = ""

    var id = UUID()

    var colliderShape: ColliderShape = .circle(radius: 50)

    init(initialPosition: Vector2D, initialVelocity: Vector2D) {
        self.transform = Transform.identity
        self.transform.position = initialPosition
        self.velocity = initialVelocity
        self.acceleration = Vector2D.zero

        self.currentBehaviour = ApproachPointBehaviour()
    }

    func spawn(renderSystem: RenderSystem, collisionSystem: CollisionSystem) {
        renderSystem.add(self)
        collisionSystem.add(collidable: self)
    }

    func onCollide(otherObject: Collidable) {
        print("enemy hit")
    }

    func update() {
        self.currentBehaviour.update(aiEntity: self)
    }

    func changeBehaviour(to behaviour: AIBehaviour) {
        self.currentBehaviour = behaviour
    }

}

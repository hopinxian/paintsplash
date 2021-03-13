//
//  Enemy.swift
//  paintsplash
//
//  Created by Cynthia Lee on 11/3/21.
//

import SpriteKit

class Enemy: AIEntity, Renderable, Transformable, Collidable {

    func buildNode() -> SKNode {
        let enemyMoveAtlas = SKTextureAtlas(named: "SlimeMove")
        var moveFrames: [SKTexture] = []

        let numImages = enemyMoveAtlas.textureNames.count

        for i in 1...numImages {
            let enemyTexture = "slime-move-\(i).png"
            moveFrames.append(enemyMoveAtlas.textureNamed(enemyTexture))
        }

        let enemySprite = SKSpriteNode(texture: moveFrames[0])

        let animateAction = SKAction.repeatForever(SKAction.animate(with: moveFrames, timePerFrame: 0.2))
        enemySprite.run(animateAction, completion: {
            print("ran animation")
        })

        enemySprite.position = CGPoint(self.transform.position)
        enemySprite.zRotation = CGFloat(self.transform.rotation)

        // TODO: find a way for size to be determined dynamically
        enemySprite.size = CGSize(width: 100, height: 100)
        
        return enemySprite
    }

    var currentBehaviour: AIBehaviour

    var velocity: Vector2D

    var acceleration: Vector2D

    var transform: Transform

    var spriteName: String = ""

    var id = UUID()

    var colliderShape: ColliderShape = .enemy(radius: 50)

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

    func update(aiGameInfo: AIGameInfo) {
        self.currentBehaviour.update(aiEntity: self, aiGameInfo: aiGameInfo)
    }

    func changeBehaviour(to behaviour: AIBehaviour) {
        self.currentBehaviour = behaviour
    }

}

extension Enemy: Hashable {
    static func == (lhs: Enemy, rhs: Enemy) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

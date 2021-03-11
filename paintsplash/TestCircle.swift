//
//  TestCircle.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//

import SpriteKit

class TestCircle: Entity, Renderable, Transformable, Movable, Collidable {
    var spriteMoveFrames: [SKTexture]?

    func buildNode() -> SKNode {
        let skNode = SKSpriteNode(imageNamed: self.spriteName)

        skNode.position = CGPoint(self.transform.position)
        skNode.zRotation = CGFloat(self.transform.rotation)

        return skNode
    }

    var colliderShape: ColliderShape = .circle(radius: 50)

    var id = UUID()
    var spriteName = "testCircle.png"

    func onCollide(otherObject: Collidable) {
        print("Hello")
    }

    var velocity: Vector2D
    var acceleration: Vector2D

    var transform: Transform

    init(initialPosition: Vector2D, initialVelocity: Vector2D) {
        self.transform = Transform.identity
        self.transform.position = initialPosition
        self.velocity = initialVelocity
        self.acceleration = Vector2D.zero
    }

    func spawn(renderSystem: RenderSystem, collisionSystem: CollisionSystem) {
        renderSystem.add(self)
        collisionSystem.add(collidable: self)
    }
}

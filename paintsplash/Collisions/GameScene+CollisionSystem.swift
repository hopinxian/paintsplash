//
//  GameScene+CollisionSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import SpriteKit

extension GameScene: SKPhysicsContactDelegate, CollisionSystem {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let bodyA = collidables[contact.bodyA],
              let bodyB = collidables[contact.bodyB] else {
            return
        }

        collisionBetween(first: bodyA, second: bodyB)
    }

    func add(collidable: Collidable) {
        if let node = nodes[collidable.id] {
            let physicsBody = collidable.colliderShape.getPhysicsBody()
            collidables[physicsBody] = collidable
            bodies[collidable.id] = physicsBody
            node.physicsBody = physicsBody
        } else {
            let skNode = SKSpriteNode()
            let physicsBody = collidable.colliderShape.getPhysicsBody()
            skNode.physicsBody = physicsBody

            collidables[physicsBody] = collidable
            bodies[collidable.id] = physicsBody
            nodes[collidable.id] = skNode
        }
    }

    func remove(collidable: Collidable) {
        if let node = nodes[collidable.id] {
            node.physicsBody = nil
        }

        bodies[collidable.id] = nil
    }

    func collisionBetween(first: Collidable, second: Collidable) {
        first.onCollide(otherObject: second)
        second.onCollide(otherObject: first)
    }
}

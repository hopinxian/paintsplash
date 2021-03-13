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

    func addCollidable(_ collidable: Collidable) {
        let physicsBody = collidable.colliderShape.getPhysicsBody()
        physicsBody.contactTestBitMask = collidable.tags.getBitMask()

        if let node = nodes[collidable.id] {
            node.physicsBody = physicsBody
        } else {
            let skNode = SKSpriteNode()
            skNode.physicsBody = physicsBody

            nodes[collidable.id] = skNode
        }

        collidables[physicsBody] = collidable
        bodies[collidable.id] = physicsBody
    }

    func removeCollidable(_ collidable: Collidable) {
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

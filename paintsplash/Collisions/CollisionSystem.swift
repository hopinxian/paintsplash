//
//  CollisionSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import SpriteKit

protocol CollisionSystem {
    func addCollidableEntity(_ collidable: CollisionComponent)
    func removeCollidableEntity(_ collidable: CollisionComponent)
    func collisionBetweenEntity(first: CollisionComponent, second: CollisionComponent)
}

class NewCollisionSystem: CollisionSystem {
    var nodes = [UUID : SKNode]()
    var bodies = [UUID: SKPhysicsBody]()
    var collidables = [SKPhysicsBody: CollisionComponent]()

    func addCollidableEntity(_ data: CollisionComponent) {
        let physicsBody = data.colliderShape.getPhysicsBody()
        physicsBody.contactTestBitMask = data.tags.getBitMask()

        if let node = nodes[data.entity.id] {
            node.physicsBody = physicsBody
        } else {
            let skNode = SKNode()
            skNode.physicsBody = physicsBody

            nodes[data.entity.id] = skNode
        }

        collidables[physicsBody] = data
        bodies[data.entity.id] = physicsBody
    }

    func removeCollidableEntity(_ data: CollisionComponent) {
        if let node = nodes[data.entity.id] {
            node.physicsBody = nil
        }

        bodies[data.entity.id] = nil
    }

    func detectCollision(_ contact: SKPhysicsContact) {
        guard let bodyA = collidables[contact.bodyA],
              let bodyB = collidables[contact.bodyB] else {
            return
        }

        collisionBetweenEntity(first: bodyA, second: bodyB)
    }

    func collisionBetweenEntity(first: CollisionComponent, second: CollisionComponent) {
        first.onCollide(second)
        second.onCollide(first)
    }
}

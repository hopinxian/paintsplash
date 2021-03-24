//
//  CollisionSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import SpriteKit

protocol CollisionSystem: System {
    func addCollidableEntity(_ entity: GameEntity)
    func removeCollidableEntity(_ entity: GameEntity)
    func collisionBetweenEntity(first: Collidable, second: Collidable)
}

class SKCollisionSystem: CollisionSystem {
    var renderSystem: SKRenderSystem

    init(renderSystem: SKRenderSystem) {
        self.renderSystem = renderSystem
    }

    func updateEntity(_ entity: GameEntity) {}

    func addCollidableEntity(_ entity: GameEntity) {
        guard let data = entity as? Collidable else {
            return
        }

        let physicsBody = data.collisionComponent.colliderShape.getPhysicsBody()
        physicsBody.contactTestBitMask = data.collisionComponent.tags.getBitMask()

        let nodeEntityMap = renderSystem.getNodeEntityMap()

        if nodeEntityMap[data] == nil {
            renderSystem.addEntity(entity)
        }

        let node = nodeEntityMap[data]
        node?.physicsBody = physicsBody
    }

    func removeCollidableEntity(_ entity: GameEntity) {
        guard let data = entity as? Collidable else {
            return
        }

        let nodeEntityMap = renderSystem.getNodeEntityMap()
        if let node = nodeEntityMap[data] {
            node.physicsBody = nil
        }
    }

    func collisionBetweenEntity(first: Collidable, second: Collidable) {
        first.onCollide(with: second)
        second.onCollide(with: first)
    }
}

class SKCollisionDetector: NSObject, SKPhysicsContactDelegate {
    let renderSystem: SKRenderSystem
    let collisionSystem: SKCollisionSystem

    init(renderSystem: SKRenderSystem, collisionSystem: SKCollisionSystem) {
        self.renderSystem = renderSystem
        self.collisionSystem = collisionSystem
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let nodeEntityMap = renderSystem.getNodeEntityMap()
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node else {
            return
        }

        guard let collidableA = nodeEntityMap[nodeA] as? Collidable,
              collidableA.collisionComponent.active,
              let collidableB = nodeEntityMap[nodeB] as? Collidable,
              collidableB.collisionComponent.active else {
            return
        }

        collisionSystem.collisionBetweenEntity(first: collidableA, second: collidableB)
    }
}


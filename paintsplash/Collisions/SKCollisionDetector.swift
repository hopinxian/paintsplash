//
//  SKCollisionDetector.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//
import Foundation
import SpriteKit

class SKCollisionDetector: NSObject, SKPhysicsContactDelegate {
    let renderSystem: SKRenderSystem
    let collisionSystem: SKCollisionSystem

    init(renderSystem: SKRenderSystem, collisionSystem: SKCollisionSystem) {
        self.renderSystem = renderSystem
        self.collisionSystem = collisionSystem
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node,
              let nodeB = contact.bodyB.node else {
            return
        }

        guard let collidableA = renderSystem.renderableFromNode(nodeA) as? Collidable,
              collidableA.collisionComponent.active,
              let collidableB = renderSystem.renderableFromNode(nodeB) as? Collidable,
              collidableB.collisionComponent.active else {
            return
        }

        collisionSystem.collisionBetweenEntity(first: collidableA, second: collidableB)
    }
}

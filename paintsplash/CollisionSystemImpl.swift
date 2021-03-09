//
//  CollisionSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 9/3/21.
//

import Foundation
import SpriteKit

class CollisionSystemImpl: NSObject, SKPhysicsContactDelegate, CollisionSystem {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let objectA = (contact.bodyA as? Collidable),
              let objectB = (contact.bodyB as? Collidable) else {
            return //or throw
        }

        collisionBetween(first: objectA, second: objectB)
    }

    func didEnd(_ contact: SKPhysicsContact) {

    }

    func collisionBetween(first: Collidable, second: Collidable) {
        first.onCollide(otherObject: second)
        second.onCollide(otherObject: first)
    }
}


protocol Collidable {
    func onCollide(otherObject: Collidable)
}

protocol CollisionSystem {
    func collisionBetween(first: Collidable, second: Collidable)
}

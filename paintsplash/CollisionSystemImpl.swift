//
//  CollisionSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 9/3/21.
//

import Foundation
import SpriteKit

protocol Collidable: Renderable {
    var colliderShape: ColliderShape { get set }
    func onCollide(otherObject: Collidable)
}

protocol CollisionSystem {
    func add(collidable: Collidable)
    func remove(collidable: Collidable)
    func collisionBetween(first: Collidable, second: Collidable)
}

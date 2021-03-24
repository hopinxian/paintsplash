//
//  Collidable.swift
//  paintsplash
//
//  Created by Farrell Nah on 9/3/21.
//

import Foundation
import SpriteKit

protocol Collidable: GameEntity {
    var collisionComponent: CollisionComponent { get }
    func onCollide(with otherObject: Collidable)
}

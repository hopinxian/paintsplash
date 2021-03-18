//
//  Collidable.swift
//  paintsplash
//
//  Created by Farrell Nah on 9/3/21.
//

import Foundation
import SpriteKit

protocol Collidable: Renderable {
    var colliderShape: ColliderShape { get set }
    var tags: Tags { get set }
    func onCollide(otherObject: Collidable)
}


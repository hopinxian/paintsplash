//
//  Renderable.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

import SpriteKit

protocol Renderable {
    var node: SKNode { get set }
    func move(to point: Vector2D)
}

extension Renderable {
    func move(to point: Vector2D) {
        node.position = CGPoint(point)
    }
}

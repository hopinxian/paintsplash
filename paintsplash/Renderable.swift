//
//  Renderable.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

import SpriteKit

protocol Renderable {
    var node: SKNode { get }
    func move(to point: CGPoint)
}

extension Renderable {
    func move(to point: CGPoint) {
        node.position = point
    }
}

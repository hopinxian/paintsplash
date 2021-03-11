//
//  Renderable.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import SpriteKit

protocol Renderable: Entity, Transformable {
    var spriteName: String { get }

    var spriteMoveFrames: [SKTexture]? { get }

    func buildNode() -> SKNode
}

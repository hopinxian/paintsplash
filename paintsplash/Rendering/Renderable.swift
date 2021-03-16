//
//  Renderable.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import SpriteKit

protocol Renderable: GameEntity, Transformable {
    var spriteName: String { get }
    var currentAnimation: Animation? { get set }
    var zPosition: Int { get set }
}

extension Renderable {
    var zPosition: Int {
        get {
            0
        }

        set {
            zPosition = newValue
        }
    }
}

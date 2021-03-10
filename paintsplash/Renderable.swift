//
//  Renderable.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//
import SpriteKit

protocol RenderSystem {
    func add(_ renderable: Renderable)
    func remove(_ renderable: Renderable)
    func updateRenderable(renderable: Renderable)
}

protocol Renderable: Entity, Transformable {
    var spriteName: String { get }
}

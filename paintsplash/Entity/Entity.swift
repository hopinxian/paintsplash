//
//  Entity.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import Foundation

protocol Entity: AnyObject {
    var id: UUID { get }

    func spawn(renderSystem: RenderSystem, collisionSystem: CollisionSystem)
    func destroy(renderSystem: RenderSystem, collisionSystem: CollisionSystem)
}

extension Entity where Self: Renderable & Collidable {
    func spawn(renderSystem: RenderSystem, collisionSystem: CollisionSystem) {
        renderSystem.addRenderable(self)
        collisionSystem.addCollidable(self)
    }

    func destroy(renderSystem: RenderSystem, collisionSystem: CollisionSystem) {
        renderSystem.removeRenderable(self)
        collisionSystem.removeCollidable(self)
    }
}

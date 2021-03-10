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
}

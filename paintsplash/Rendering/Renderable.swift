//
//  Renderable.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import SpriteKit

protocol Renderable: GameEntity {
    var renderComponent: RenderComponent { get }
    var transformComponent: TransformComponent { get }
}

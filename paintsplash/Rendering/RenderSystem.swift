//
//  RenderableSystem.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

import SpriteKit

protocol RenderSystem: System {
    var renderables: [GameEntity: Renderable] { get set }
    func updateEntity(_ entity: GameEntity, _ renderable: Renderable)
}

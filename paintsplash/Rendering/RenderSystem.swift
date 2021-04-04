//
//  RenderableSystem.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

import SpriteKit

protocol RenderSystem: System {
    var renderables: [EntityID: Renderable] { get set }
    var wasModified: [EntityID: Renderable] { get set }
    func updateEntity(_ entity: EntityID, _ renderable: Renderable)
}

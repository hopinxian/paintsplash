//
//  MockRenderSystem.swift
//  paintsplashTests
//
//  Created by Farrell Nah on 21/3/21.
//

import XCTest
@testable import paintsplash

class MockRenderSystem: RenderSystem {
    var renderables: [EntityID : Renderable] = [:]
    
    var activeRenderables = [Renderable]()
    var updatedRenderables = [Renderable]()
    var renderableAnimations = [UUID: Animation]()
    var renderableSubviews = [UUID: [RenderInfo]]()
    
    func updateEntity(_ entity: EntityID, _ renderable: Renderable) {
        guard activeRenderables.contains(where: { $0 === renderable }) else {
            XCTFail("Tried to update a non active renderable")
            return
        }

        updatedRenderables.append(renderable)
    }
    
    func addEntity(_ entity: GameEntity) {
        activeRenderables.append(entity as! Renderable)
    }
    
    func removeEntity(_ entity: GameEntity) {
        activeRenderables.removeAll(where: { $0 === entity })
    }
    
    func updateEntities() {

    }
  
    func animateRenderable(renderable: Renderable, animation: Animation, interrupt: Bool) {
        guard renderableAnimations[renderable.id.id] == nil || interrupt else {
            XCTFail("Tried to start an animation when an animation is already running")
            return
        }

        renderableAnimations[renderable.id.id] = animation
    }

    func addSubview(renderable: Renderable, subviewInfo: RenderInfo) {
        if var subviews = renderableSubviews[renderable.id.id] {
            subviews.append(subviewInfo)
        } else {
            renderableSubviews[renderable.id.id] = [subviewInfo]
        }
    }
}

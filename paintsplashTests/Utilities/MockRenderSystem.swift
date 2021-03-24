//
//  MockRenderSystem.swift
//  paintsplashTests
//
//  Created by Farrell Nah on 21/3/21.
//

import XCTest
@testable import paintsplash

class MockRenderSystem: RenderSystem {
    var activeRenderables = [Renderable]()
    var updatedRenderables = [Renderable]()
    var renderableAnimations = [UUID: Animation]()
    var renderableSubviews = [UUID: [RenderInfo]]()

    func addRenderable(_ renderable: Renderable) {
        activeRenderables.append(renderable)
    }

    func removeRenderable(_ renderable: Renderable) {
        activeRenderables.removeAll(where: { $0 === renderable })
    }

    func updateRenderable(_ renderable: Renderable) {
        guard activeRenderables.contains(where: { $0 === renderable }) else {
            XCTFail("Tried to update a non active renderable")
            return
        }

        updatedRenderables.append(renderable)
    }

    func animateRenderable(renderable: Renderable, animation: Animation, interrupt: Bool) {
        guard renderableAnimations[renderable.id] == nil || interrupt else {
            XCTFail("Tried to start an animation when an animation is already running")
            return
        }

        renderableAnimations[renderable.id] = animation
    }

    func addSubview(renderable: Renderable, subviewInfo: RenderInfo) {
        if var subviews = renderableSubviews[renderable.id] {
            subviews.append(subviewInfo)
        } else {
            renderableSubviews[renderable.id] = [subviewInfo]
        }
    }
}

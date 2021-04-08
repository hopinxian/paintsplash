//
//  MockRenderSystem.swift
//  paintsplashTests
//
//  Created by Farrell Nah on 21/3/21.
//
//  swiftlint:disable force_cast

import XCTest
@testable import paintsplash

class MockRenderSystem: RenderSystem {
    var renderables: [EntityID: Renderable] = [:]
    var wasModified: [EntityID: Renderable] = [:]

    var activeRenderables = [Renderable]()
    var updatedRenderables = [Renderable]()
    var renderableAnimations = [UUID: Animation]()
//    var renderableSubviews = [UUID: [RenderInfo]]()

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

    func updateEntities(_ deltaTime: Double) {

    }
}

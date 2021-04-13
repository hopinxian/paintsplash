//
//  MockGameManager.swift
//  paintsplashTests
//
//  Created by admin on 3/4/21.
//

@testable import paintsplash

class MockGameManager: GameManager {
    var entities = Set<GameEntity>()

    var renderSystem = MockRenderSystem()
    var collisionSystem = MockCollisionSystem()

    var uiEntities = Set<GameEntity>()

    init() {
        EventSystem.entityChangeEvents.addEntityEvent.subscribe(listener: { [weak self] event in self?.onAddEntity(event: event) })
        EventSystem.entityChangeEvents.removeEntityEvent.subscribe(listener: { [weak self] event in self?.onRemoveEntity(event: event) })
        EventSystem.entityChangeEvents.addUIEntityEvent.subscribe(listener: { [weak self] event in self?.onAddUIEntity(event: event) })
        EventSystem.entityChangeEvents.removeUIEntityEvent.subscribe(listener: { [weak self] event in self?.onRemoveUIEntity(event: event) })
    }

    private func onAddEntity(event: AddEntityEvent) {
        addObject(event.entity)
    }

    private func onRemoveEntity(event: RemoveEntityEvent) {
        removeObject(event.entity)
    }

    private func onAddUIEntity(event: AddUIEntityEvent) {
        uiEntities.insert(event.entity)
        addObjectToSystems(event.entity)
    }

    private func onRemoveUIEntity(event: RemoveUIEntityEvent) {
        uiEntities.remove(event.entity)
        removeObjectFromSystems(event.entity)
    }

    private func addObjectToSystems(_ object: GameEntity) {
        renderSystem.addEntity(object)
        collisionSystem.addEntity(object)
    }

    private func removeObjectFromSystems(_ object: GameEntity) {
        renderSystem.removeEntity(object)
        collisionSystem.removeEntity(object)
    }

    func addObject(_ object: GameEntity) {
        entities.insert(object)
        addObjectToSystems(object)
    }

    func removeObject(_ object: GameEntity) {
        entities.remove(object)
        removeObjectFromSystems(object)
    }

    func update(_ deltaTime: Double) {
        renderSystem.updateEntities(deltaTime)
        collisionSystem.updateEntities(deltaTime)
    }
}

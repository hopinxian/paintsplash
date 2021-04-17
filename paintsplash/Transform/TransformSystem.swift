//
//  TransformSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 1/4/21.
//

protocol TransformSystem: System {
    var transformables: [EntityID: Transformable] { get set }
}

class WorldTransformSystem: TransformSystem {
    var transformables = [EntityID: Transformable]()
    private var updatedThisFrame = [EntityID: Transformable]()

    func addEntity(_ entity: GameEntity) {
        guard let transformable = entity as? Transformable else {
            return
        }

        transformables[entity.id] = transformable
    }

    func removeEntity(_ entity: GameEntity) {
        transformables[entity.id] = nil
    }

    func updateEntities(_ deltaTime: Double) {
        for (_, transformable) in transformables {
            updateEntity(transformable)
        }

        updatedThisFrame = [:]
    }

    private func updateEntity(_ transformable: Transformable) {
        guard updatedThisFrame[transformable.id] == nil else {
            return
        }

        if let parent = transformable.transformComponent.parentID,
           let parentTransformable = transformables[parent] {
            updateWithParent(parent: parentTransformable, transformable: transformable)
        } else {
            updateWithoutParent(transformable: transformable)
        }
        updatedThisFrame[transformable.id] = transformable
    }

    private func updateWithParent(parent: Transformable, transformable: Transformable) {
        updateEntity(parent)

        transformable.transformComponent.worldPosition =
            parent.transformComponent.worldPosition +
            transformable.transformComponent.localPosition
    }

    private func updateWithoutParent(transformable: Transformable) {
        transformable.transformComponent.worldPosition = transformable.transformComponent.localPosition
    }
}

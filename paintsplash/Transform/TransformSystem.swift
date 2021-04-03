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
    var transformables = [EntityID : Transformable]()

    func addEntity(_ entity: GameEntity) {
        guard let transformable = entity as? Transformable else {
            return
        }

        transformables[entity.id] = transformable
    }

    func removeEntity(_ entity: GameEntity) {
        transformables[entity.id] = nil
    }

    func updateEntities() {
        for (_, transformable) in transformables {
            updateEntity(transformable)
        }
    }

    private func updateEntity(_ transformable: Transformable) {
        if let parent = transformable.transformComponent.parentID {
            updateWithParent(parent: parent, transformable: transformable)
        } else {
            updateWithoutParent(transformable: transformable)
        }
    }

    private func updateWithParent(parent: EntityID, transformable: Transformable) {
        if let parentTransformable = transformables[parent] {
            transformable.transformComponent.worldPosition =
                parentTransformable.transformComponent.worldPosition +
                transformable.transformComponent.localPosition
        }
    }

    private func updateWithoutParent(transformable: Transformable) {
        transformable.transformComponent.worldPosition = transformable.transformComponent.localPosition
    }
}

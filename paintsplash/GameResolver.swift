//
//  GameResolver.swift
//  paintsplash
//
//  Created by admin on 9/4/21.
//

class GameResolver {
    static func resolve(manager: MultiplayerClient, with data: SystemData) {
        let entityIDs = Set(manager.entities.map({ $0.id }))

        for entity in data.entityData.entities where !entityIDs.contains(entity) {
            addNetowrkedEntity(entity: entity, data: data)
        }

        var colorables = [EntityID: Colorable]()
        manager.entities.forEach({ entity in
            if let colorable = entity as? Colorable {
                colorables[entity.id] = colorable
            }
        })

        for entity in data.entityData.entities {
            updateNetworkedRenderable(data, entity, manager)
            updateNetworkedAnimatable(data, entity, manager)
            updateNetworkedColorable(data, entity, &colorables)
        }

        for entity in entityIDs where !data.entityData.entities.contains(entity) {
            manager.entities.first(where: { gameEntity in gameEntity.id == entity })?.destroy()
        }
    }

    static func addNetowrkedEntity(entity: EntityID, data: SystemData) {
        let renderComponent =
            data.renderSystemData?.renderables[entity]?.renderComponent
        let animationComponent =
            data.animationSystemData?.animatables[entity]?.animationComponent
        let transformComponent =
            data.renderSystemData?.renderables[entity]?.transformComponent
        let colorComponent = data.colorSystemData?.colorables[entity]?.color

        let newEntity = NetworkedEntity(
            id: entity,
            renderComponent: renderComponent,
            transformComponent: transformComponent,
            animationComponent: animationComponent,
            color: colorComponent
        )
        newEntity.spawn()
    }

    static func updateNetworkedRenderable(_ data: SystemData, _ entity: EntityID, _ manager: MultiplayerClient) {
        if let renderable = data.renderSystemData?.renderables[entity] {
            let renderComponent = renderable.renderComponent
            let transformComponent = renderable.transformComponent
            renderComponent.wasModified = true
            transformComponent.wasModified = true
            manager.renderSystem.renderables[entity]?.renderComponent = renderComponent
            manager.renderSystem.renderables[entity]?.transformComponent = transformComponent
        }
    }

    static func updateNetworkedAnimatable(_ data: SystemData, _ entity: EntityID, _ manager: MultiplayerClient) {
        if let animatable = data.animationSystemData?.animatables[entity] {
            let animationComponent = animatable.animationComponent
            animationComponent.wasModified = true
            animationComponent.animationToPlay = animationComponent.currentAnimation
            manager.animationSystem.animatables[entity]?.animationComponent = animationComponent
        }
    }

    static func updateNetworkedColorable(_ data: SystemData,
                                         _ entity: EntityID,
                                         _ colorables: inout [EntityID: Colorable]) {
        if let colorable = data.colorSystemData?.colorables[entity] {
            let color = colorable.color
            colorables[entity]?.color = color
        }
    }
}

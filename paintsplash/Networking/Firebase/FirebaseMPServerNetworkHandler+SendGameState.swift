//
//  FirebaseMPServerNetworkHandler+SendGameState.swift
//  paintsplash
//
//  Created by Cynthia Lee on 18/4/21.
//

import Foundation

extension FirebaseMPServerNetworkHandler {

    func sendGameStateToDatabase() {
        guard let uiEntities = multiplayerServer?.uiEntities,
            let entities = multiplayerServer?.entities,
            let renderSystem = multiplayerServer?.renderSystem,
            let animationSystem = multiplayerServer?.animationSystem else {
            return
        }

        let uiEntityIDs = Set(uiEntities.map { $0.id })
        let renderSystemData = getRenderSystemData(from: renderSystem, exclude: uiEntityIDs)
        let animationSystemData = getAnimationSystemData(from: animationSystem, exclude: uiEntityIDs)
        let colorSystemData = getColorSystemData(from: entities, exclude: uiEntityIDs)
        let entityData = getEntityData(from: entities, exclude: uiEntityIDs)

        let systemData = SystemData(
            entityData: entityData,
            renderSystemData: renderSystemData,
            animationSystemData: animationSystemData,
            colorSystemData: colorSystemData
        )

        gameConnectionHandler.sendSystemData(data: systemData, gameID: self.gameId)
    }

    private func getRenderSystemData(from renderSystem: RenderSystem,
                                     exclude uiEntities: Set<EntityID>) -> RenderSystemData {
        let renderablesToSend = renderSystem.wasModified.filter { !uiEntities.contains($0.key) }
        return RenderSystemData(from: renderablesToSend)
    }

    private func getAnimationSystemData(from animationSystem: AnimationSystem,
                                        exclude uiEntities: Set<EntityID>) -> AnimationSystemData {
        let animatablesToSend = animationSystem.wasModified.filter { !uiEntities.contains($0.key) }
        return AnimationSystemData(from: animatablesToSend)
    }

    private func getEntityData(from entities: Set<GameEntity>, exclude uiEntities: Set<EntityID>) -> EntityData {
        EntityData(from: entities.filter { !uiEntities.contains($0.id) })
    }

    private func getColorSystemData(from entities: Set<GameEntity>,
                                    exclude uiEntities: Set<EntityID>) -> ColorSystemData {

        var colorables = [EntityID: Colorable]()

        for entity in entities where !uiEntities.contains(entity.id) {
            if let colorable = entity as? Colorable {
                colorables[entity.id] = colorable
            }
        }

        return ColorSystemData(from: colorables)
    }
}

//
//  FirebaseMPServerNetworkHandler+SendGameState.swift
//  paintsplash
//
//  Created by Cynthia Lee on 18/4/21.
//

import Foundation

extension FirebaseMPServerNetworkHandler {
    func sendGameStateToDatabase(uiEntities: Set<GameEntity>, entities: Set<GameEntity>,
                                 renderSystem: RenderSystem, animationSystem: AnimationSystem) {
        let uiEntityIDs = Set(uiEntities.map({ $0.id }))
        let entityData = EntityData(from: entities.filter({ !uiEntityIDs.contains($0.id) }))

        let renderablesToSend = renderSystem.wasModified.filter({ entityID, _ in
            !uiEntityIDs.contains(entityID)
        })

        let renderSystemData = RenderSystemData(from: renderablesToSend)

        let animatablesToSend = animationSystem.wasModified.filter({ entityID, _ in
            !uiEntityIDs.contains(entityID)
        })
        let animationSystemData = AnimationSystemData(from: animatablesToSend)

        var colorables = [EntityID: Colorable]()
        entities.forEach({ entity in
            if let colorable = entity as? Colorable, !uiEntityIDs.contains(entity.id) {
                colorables[entity.id] = colorable
            }
        })

        let colorSystemData = ColorSystemData(from: colorables)

        let systemData = SystemData(
            entityData: entityData,
            renderSystemData: renderSystemData,
            animationSystemData: animationSystemData,
            colorSystemData: colorSystemData
        )
        gameConnectionHandler.sendSystemData(data: systemData, gameID: self.gameId)
    }
    
}

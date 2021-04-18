//
//  FirebaseMPClientNetworkHandler+SendPlayerData.swift
//  paintsplash
//
//  Created by Cynthia Lee on 18/4/21.
//

extension FirebaseMPClientNetworkHandler {
    func sendPlayerDataToDatabase() {
        guard let player = multiplayerClient?.player else {
            return
        }

        let systemData = getSystemDataToSend(player: player)

        let path = DataPaths.joinPaths(
            DataPaths.games, roomInfo.gameID,
            DataPaths.game_players, player.id.id,
            DataPaths.game_client_player)

        connectionHandler.send(
            to: path,
            data: systemData,
            shouldRemoveOnDisconnect: true,
            onComplete: nil,
            onError: nil
        )
    }

    private func getSystemDataToSend(player: Player) -> SystemData {
        let entityData = EntityData(from: [player])
        let renderSystemData = getRenderSystemData(player: player)
        let animationSystemData = getAnimationSystemData(player: player)

        let systemData = SystemData(
            entityData: entityData,
            renderSystemData: renderSystemData,
            animationSystemData: animationSystemData,
            colorSystemData: nil
        )

        return systemData
    }

    private func getRenderSystemData(player: Player) -> RenderSystemData {
        let renderableToSend: [EntityID: Renderable] = [player.id: player]
        return RenderSystemData(from: renderableToSend)
    }

    private func getAnimationSystemData(player: Player) -> AnimationSystemData {
        let animatableToSend: [EntityID: Animatable] = [player.id: player]
        return AnimationSystemData(from: animatableToSend)
    }
}

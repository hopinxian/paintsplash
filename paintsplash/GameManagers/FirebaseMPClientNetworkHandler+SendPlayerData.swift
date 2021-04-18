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

        let entityData = EntityData(from: [player])
        let renderableToSend: [EntityID: Renderable] = [player.id: player]
        let renderSystemData = RenderSystemData(from: renderableToSend)

        let animatableToSend: [EntityID: Animatable] = [player.id: player]
        let animataionSystemData = AnimationSystemData(from: animatableToSend)
        let systemData = SystemData(
            entityData: entityData,
            renderSystemData: renderSystemData,
            animationSystemData: animataionSystemData,
            colorSystemData: nil
        )
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

}

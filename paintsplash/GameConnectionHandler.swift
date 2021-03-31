//
//  GameConnectionHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 30/3/21.
//

protocol GameConnectionHandler {
    func addEntity(gameId: String, entity: GameEntity)

    func sendPlayerState(gameId: String, playerId: String, playerState: PlayerStateInfo)

    func observePlayerState(gameId: String, playerId: String, onChange: ((PlayerStateInfo) -> Void)?)
}

struct PlayerStateInfo: Codable {
    var health: Int
}

//
//  GameConnectionHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 30/3/21.
//
import Foundation

protocol GameConnectionHandler {
    func addEntity(gameId: String, entity: GameEntity)

    func sendPlayerState(gameId: String, playerId: String, playerState: PlayerStateInfo)

    func observePlayerState(gameId: String, playerId: String, onChange: ((PlayerStateInfo) -> Void)?)

    func sendPlayerMoveInput(gameId: String, playerId: String, playerMoveEvent: PlayerMoveEvent)

    func observePlayerMoveInput(gameId: String, playerId: String, onChange: ((PlayerMoveEvent) -> Void)?)
}

struct PlayerStateInfo: Codable {
    var playerId: UUID
    var health: Int
}

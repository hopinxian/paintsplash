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

    func sendPlayerEvent<T: Codable>(gameId: String, playerId: String, action: T) where T: Event

    func observePlayerEvent<T: Codable>(gameId: String, playerId: String, onChange: ((T) -> Void)?) where T: Event
}

struct PlayerStateInfo: Codable {
    var playerId: UUID
    var health: Int
}

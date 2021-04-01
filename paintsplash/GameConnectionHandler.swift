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

    func sendPlayerShootInput(gameId: String, playerId: String, playerShootEvent: PlayerShootEvent)

    func observePlayerShootInput(gameId: String, playerId: String, onChange: ((PlayerShootEvent) -> Void)?)

    func sendPlayerChangeWeapon(gameId: String, playerId: String, changeWeaponEvent: PlayerChangeWeaponEvent)

    func observePlayerChangeWeapon(gameId: String, playerId: String, onChange: ((PlayerChangeWeaponEvent) -> Void)?)
}

struct PlayerStateInfo: Codable {
    var playerId: EntityID
    var health: Int
}

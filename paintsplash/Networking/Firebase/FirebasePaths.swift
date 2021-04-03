//
//  FirebasePaths.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.
//

enum FirebasePaths {
    static let rooms = "rooms"
    static let rooms_id = "roomId"
    static let rooms_isOpen = "isOpen"
    static let rooms_players = "players"
    static let rooms_gameId = "gameId"
    static let rooms_gameStarted = "started"

    static let player_name = "playerName"
    static let player_UUID = "playerId"
    static let player_isHost = "isHost"

    static let games = "games"
    static let game_roomId = "game_roomId"
    static let game_UUID = "gameId"
    static let game_entities = "entities"
    static let game_players = "players"
    static let game_isRunning = "running"
    static let player_moveInput = "moveInput"
    static let player_shootInput = "shootInput"
    static let player_weaponChoice = "weaponChoice"
    static let player_ammoUpdate = "ammo"
    static let player_healthUpdate = "health"
    static let player_music = "music"
    static let player_soundEffect = "soundEffect"

    static let entity_renderable = "renderable"
    static let entity_transform = "transform"

    static let render_system = "render_system"
    static let animation_system = "animation_system"
    static let color_system = "color_system"
    static let systems = "systems"

    static func joinPaths(_ paths: String ...) -> String {
        paths.joined(separator: "/")
    }
}

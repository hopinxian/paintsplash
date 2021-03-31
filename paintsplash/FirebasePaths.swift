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
//    static let rooms_host = "host"
//    static let rooms_guest = "guest"
    static let rooms_players = "players"

    static let player_name = "playerName"
    static let player_UUID = "playerId"
    static let player_isHost = "isHost"

    static let games = "games"

    static func joinPaths(_ paths: String ...) -> String {
        paths.joined(separator: "/")
    }
}

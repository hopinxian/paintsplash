//
//  RoomInfo.swift
//  paintsplash
//
//  Created by Cynthia Lee on 28/3/21.
//
struct RoomInfo: Codable {
    var roomId: String
    var host: PlayerInfo
    var players: [String: PlayerInfo]?
    var isOpen: Bool
    var gameId: String?

    init(roomId: String, host: PlayerInfo, players: [String: PlayerInfo], isOpen: Bool) {
        // assert(!players.contains(host))
        self.roomId = roomId
        self.host = host
        self.players = players
        self.isOpen = isOpen
    }

    mutating func setGameId(gameId: String) {
        self.gameId = gameId
    }

    mutating func closeGame() {
        self.isOpen = false
    }
}

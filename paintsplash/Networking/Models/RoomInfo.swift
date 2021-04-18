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
    var started: Bool
    var gameID: String

    init(roomId: String, host: PlayerInfo, players: [String: PlayerInfo], isOpen: Bool) {
        self.roomId = roomId
        self.host = host
        self.players = players
        self.isOpen = isOpen
        self.started = false
        self.gameID = ""
    }

    mutating func closeGame() {
        self.isOpen = false
    }
}

//
//  GameStateInfo.swift
//  paintsplash
//
//  Created by Cynthia Lee on 30/3/21.
//

struct GameStateInfo: Codable {
    var roomId: String
    var gameId: String
    var entities: [String: NetworkEntity]

    init(roomId: String, gameId: String) {
        self.roomId = roomId
        self.gameId = gameId
        self.entities = [:]
    }

    mutating func setGameId(gameId: String) {
        self.gameId = gameId
    }
}

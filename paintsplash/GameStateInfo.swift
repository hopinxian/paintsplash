//
//  GameStateInfo.swift
//  paintsplash
//
//  Created by Cynthia Lee on 30/3/21.
//

struct GameStateInfo: Codable {
    var roomId: String
    var gameId: String
    var isRunning: Bool
    var entities: [String: NetworkEntity]

    init(roomId: String, gameId: String, isRunning: Bool) {
        self.roomId = roomId
        self.gameId = gameId
        self.isRunning = isRunning
        self.entities = [:]
    }

    mutating func setGameId(gameId: String) {
        self.gameId = gameId
    }

    mutating func setGameIsRunning(_ isRunning: Bool) {
        self.isRunning = isRunning
    }
}

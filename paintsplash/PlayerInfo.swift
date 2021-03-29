//
//  PlayerInfo.swift
//  paintsplash
//
//  Created by Cynthia Lee on 29/3/21.
//

import Foundation

struct PlayerInfo: Codable, Equatable {
    var playerUUID: String
    var playerName: String

    init(playerUUID: String, playerName: String) {
        self.playerUUID = playerUUID
        self.playerName = playerName
    }
}

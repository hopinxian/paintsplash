//
//  RoomInfo.swift
//  paintsplash
//
//  Created by Cynthia Lee on 28/3/21.
//

import Foundation

struct RoomInfo: Codable {
    var roomId: String
    var host: PlayerInfo
    var players: [PlayerInfo]
    var isOpen: Bool

    init(roomId: String, host: PlayerInfo, players: [PlayerInfo], isOpen: Bool) {
        assert(!players.contains(host))
        self.roomId = roomId
        self.host = host
        self.players = players
        self.isOpen = isOpen
    }
}

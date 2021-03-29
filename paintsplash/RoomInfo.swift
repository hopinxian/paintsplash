//
//  RoomInfo.swift
//  paintsplash
//
//  Created by Cynthia Lee on 28/3/21.
//

import Foundation

struct RoomInfo {
    var roomId: String
    var hostName: String
    var guestName: String
    var isOpen: Bool

    init(from roomDict: [String: AnyObject]) {
        // Convert players into host and guestnames
        var hostName = String()
        var guestName = String()

        let players = roomDict[FirebasePaths.rooms_players] as? [String: AnyObject] ?? [:]
        players.forEach { (_, player) in
            guard let playerDict = player as? [String: AnyObject] else {
                return
            }
            let playerInfo = PlayerInfo(from: playerDict)
            if playerInfo.isHost {
                hostName = playerInfo.playerName
            } else {
                guestName = playerInfo.playerName
            }
        }

        self.roomId = roomDict[FirebasePaths.rooms_id] as? String ?? ""
        self.isOpen = roomDict[FirebasePaths.rooms_isOpen] as? Bool ?? true
        self.hostName = hostName
        self.guestName = guestName

        // return RoomInfo(roomId: roomId, hostName: hostName, guestName: guestName, isOpen: isOpen)
    }
}

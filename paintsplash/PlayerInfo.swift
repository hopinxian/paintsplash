//
//  PlayerInfo.swift
//  paintsplash
//
//  Created by Cynthia Lee on 29/3/21.
//

import Foundation

struct PlayerInfo {
    var playerUUID: String
    var playerName: String
    var isHost: Bool

    init(from firebaseDict: [String: AnyObject]) {
        let playerID = firebaseDict[FirebasePaths.player_UUID] as? String ?? ""
        let playerName = firebaseDict[FirebasePaths.player_name] as? String ?? ""
        let isHost = firebaseDict[FirebasePaths.player_isHost] as? Bool ?? false

        self.playerUUID = playerID
        self.playerName = playerName
        self.isHost = isHost
    }

    init(uuid: String, name: String, isHost: Bool) {
        self.playerUUID = uuid
        self.playerName = name
        self.isHost = isHost
    }

    func toPlayerDict() -> [String: AnyObject] {
        var playerDict: [String: AnyObject] = [:]

        playerDict[FirebasePaths.player_UUID] = self.playerUUID as AnyObject
        playerDict[FirebasePaths.player_name] = self.playerName as AnyObject
        playerDict[FirebasePaths.player_isHost] = self.isHost as AnyObject

        return playerDict
    }
}

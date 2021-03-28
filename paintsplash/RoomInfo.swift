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

    static func getRoomInfoFirebase(roomId: String, from roomDict: [String: AnyObject]) -> RoomInfo? {
        guard let hostName = roomDict[FirebasePaths.rooms_roomId_host] as? String,
              let guestName = roomDict[FirebasePaths.rooms_roomId_guest] as? String,
              let isOpen = roomDict[FirebasePaths.rooms_roomId_isOpen] as? Bool else {
            return nil
        }
        return RoomInfo(roomId: roomId, hostName: hostName, guestName: guestName, isOpen: isOpen)
    }
}

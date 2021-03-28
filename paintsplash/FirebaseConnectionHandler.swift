//
//  FirebaseConnectionHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.
//

import Firebase

class FirebaseConnectionHandler: ConnectionHandler {

    private var databaseRef = Database.database().reference()

    func createRoom(hostName: String, onSuccess: ((RoomInfo) -> Void)?, onError: ((Error) -> Void)?) {
        // Generate unique room code to return to player
        let roomId = randomFourCharString()
        let roomRef = databaseRef.child(FirebasePaths.rooms).child(roomId)
        roomRef.observeSingleEvent(of: .value, with: { snapshot in

            // Room already exists, try creating another one
            if snapshot.value as? [String: AnyObject] != nil {
                self.createRoom(hostName: hostName, onSuccess: onSuccess, onError: onError)
                return
            }

            // var players: [String: AnyObject] = [:]
            // TODO: add players
            // var selfPlayer: [String: AnyObject] = [FirebasePaths.pla : hostName]

            var roomInfo: [String: AnyObject] = [:]
            roomInfo[FirebasePaths.rooms_roomId_host] = hostName as AnyObject
            roomInfo[FirebasePaths.rooms_roomId_isOpen] = true as AnyObject
            // roomInfo[FirebasePaths.rooms_roomId_players] = players as AnyObject

            roomRef.setValue(roomInfo, withCompletionBlock: { error, ref in
                if let error = error {
                    onError?(error)
                    return
                }

                ref.onDisconnectRemoveValue()

                onSuccess?(RoomInfo(roomId: roomId, hostName: hostName, guestName: nil))
            })
        })
    }

    private func randomFourCharString() -> String {
        var string = ""
        for _ in 0..<4 {
            string += String(Int.random(in: 0...9))
        }
        return string
    }

    func joinRoom(guestName: String, roomId: String, onSuccess: ((RoomInfo) -> Void)?,
                  onError: (() -> Void)?, onRoomIsClosed: (() -> Void)?,
                  onRoomNotExist: (() -> Void)?) {
        print("Try to join room \(roomId)")
        // Try to join a room
        let roomRef = databaseRef.child(FirebasePaths.rooms).child(roomId)
        roomRef.observeSingleEvent(of: .value, with: { snapshot in
            // Room does not exist
            guard let room = snapshot.value as? [String: AnyObject] else {
                onRoomNotExist?()
                return
            }

            guard let isOpen = room[FirebasePaths.rooms_roomId_isOpen] as? Bool else {
                onError?()
                return
            }

            if !isOpen {
                onRoomIsClosed?()
                return
            }

            roomRef.child(FirebasePaths.rooms_roomId_isOpen).setValue(false as AnyObject)

            let roomInfo = RoomInfo(roomId: roomId,
                                    hostName: room[FirebasePaths.rooms_roomId_host] as? String,
                                    guestName: guestName)

            onSuccess?(roomInfo)
        })
    }

    func leaveRoom(roomId: String, onSuccess: (() -> Void)?, onError: ((Error) -> Void)?) {

    }

    func getAllRooms() {
        databaseRef.child(FirebasePaths.rooms).getData(completion: { error, snapshot in
            if let error = error {
                print("Error fetching all rooms \(error)")
                return
            }
            print("Fetched all rooms: \(snapshot)")

        })
    }
}

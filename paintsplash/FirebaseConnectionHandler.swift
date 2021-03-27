//
//  FirebaseConnectionHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.
//

import Firebase

class FirebaseConnectionHandler: ConnectionHandler {
    var databaseRef = Database.database().reference()

    func createRoom(hostName: String, onSuccess: ((String) -> Void)?, onError: ((Error) -> Void)?) {
        // Generate unique room code to return to player
        let roomId = randomFourCharString()
        let roomRef = databaseRef.child(FirebasePaths.rooms).child(roomId)
        roomRef.observeSingleEvent(of: .value, with: { snapshot in

            // Room already exists, try creating another one
            if snapshot.value as? [String: AnyObject] != nil {
                self.createRoom(hostName: hostName, onSuccess: onSuccess, onError: onError)
                return
            }

            var roomInfo: [String : AnyObject] = [:]
            roomInfo[FirebasePaths.rooms_roomId] = roomId as AnyObject
            roomInfo[FirebasePaths.rooms_isOpen] = true as AnyObject

            roomRef.setValue(roomInfo, withCompletionBlock: { error, ref in
                if let error = error {
                    onError?(error)
                    return
                }

                ref.onDisconnectRemoveValue()

                onSuccess?(roomId)
            })
        })
    }

    func randomFourCharString() -> String {
        var string = ""
        for _ in 0..<4 {
            string += String(Int.random(in: 0...9))
        }
        return string
    }

    func joinRoom(guestName: String, roomId: String, onSuccess: (() -> Void)?, onRoomNotExist: (() -> Void)?) {
        // Try to join a room
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

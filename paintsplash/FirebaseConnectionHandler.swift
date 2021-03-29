//
//  FirebaseConnectionHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.
//

import Firebase

struct FirebaseObserver {
    let handle: DatabaseHandle
    let reference: DatabaseReference

    init(handle: DatabaseHandle, reference: DatabaseReference) {
        self.handle = handle
        self.reference = reference
    }
}

class FirebaseConnectionHandler: LobbyHandler {
    private var databaseRef = Database.database().reference()

    private var observers: [FirebaseObserver] = []

    deinit {
        // detach all observers
        observers.forEach { observer in
            observer.reference.removeObserver(withHandle: observer.handle)
        }
    }

    func createRoom(player: PlayerInfo, onSuccess: ((RoomInfo) -> Void)?, onError: ((Error) -> Void)?) {
        // Generate unique room code to return to player
        let roomId = randomFourCharString()
        let roomRef = databaseRef.child(FirebasePaths.rooms).child(roomId)
        roomRef.observeSingleEvent(of: .value, with: { [weak self] snapshot in

            // Room already exists, try creating another one
            if snapshot.value as? [String: AnyObject] != nil {
                self?.createRoom(player: player, onSuccess: onSuccess, onError: onError)
                return
            }

            let hostId = player.playerUUID

            let playerDict = player.toPlayerDict()
            let players = [hostId: playerDict]

            var roomInfo: [String: AnyObject] = [:]
            roomInfo[FirebasePaths.rooms_isOpen] = true as AnyObject
            roomInfo[FirebasePaths.rooms_id] = roomId as AnyObject
            roomInfo[FirebasePaths.rooms_players] = players as AnyObject

            roomRef.setValue(roomInfo, withCompletionBlock: { error, ref in
                if let error = error {
                    onError?(error)
                    return
                }

                ref.onDisconnectRemoveValue()

                // TODO
                onSuccess?(RoomInfo(from: roomInfo))
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

    func joinRoom(player: PlayerInfo, roomId: String, onSuccess: ((RoomInfo) -> Void)?,
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

            guard let isOpen = room[FirebasePaths.rooms_isOpen] as? Bool else {
                print("error with database schema")
                onError?()
                return
            }

            if !isOpen {
                onRoomIsClosed?()
                return
            }
            // TODO: check if we should close room immediately

            let players = room[FirebasePaths.rooms_players] as? [String: AnyObject] ?? [:]
            // check that player doesn't already exist
            guard players[player.playerUUID] == nil else {
                print("player already exists")
                onError?()
                return
            }

            // Add guest as one of the players
            let guestDict = player.toPlayerDict()
            let guestRef = roomRef.child(FirebasePaths.rooms_players).child(player.playerUUID)
            guestRef.setValue(guestDict, withCompletionBlock: { error, ref in
                if let err = error {
                    // TODO: better error handling
                    print("error setting guest ref")
                    onError?()
                }

                guestRef.onDisconnectRemoveValue()
            })
        })
    }

    func observeRoom(roomId: String, onRoomChange: ((RoomInfo) -> Void)?, onRoomClose: (() -> Void)?,
                     onError: (() -> Void)?) {
        let roomRef = databaseRef.child(FirebasePaths.rooms).child(roomId)
        let observerHandle = roomRef.observe(.value, with: { snapshot in
            print("Room changed \(snapshot)")
            guard let room = snapshot.value as? [String: AnyObject] else {
                // room closed or does not exist
                onRoomClose?()
                return
            }

            let updatedRoomInfo = RoomInfo(from: room)
            onRoomChange?(updatedRoomInfo)
        })

        self.observers.append(FirebaseObserver(handle: observerHandle, reference: roomRef))
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

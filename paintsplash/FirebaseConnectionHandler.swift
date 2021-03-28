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

class FirebaseConnectionHandler: ConnectionHandler {

    private var databaseRef = Database.database().reference()

    private var observers: [FirebaseObserver] = []

    deinit {
        // detach all observers
        observers.forEach { observer in
            observer.reference.removeObserver(withHandle: observer.handle)
        }
    }

    func createRoom(hostName: String, onSuccess: ((RoomInfo) -> Void)?, onError: ((Error) -> Void)?) {
        // Generate unique room code to return to player
        let roomId = randomFourCharString()
        let roomRef = databaseRef.child(FirebasePaths.rooms).child(roomId)
        roomRef.observeSingleEvent(of: .value, with: { [weak self] snapshot in

            // Room already exists, try creating another one
            if snapshot.value as? [String: AnyObject] != nil {
                self?.createRoom(hostName: hostName, onSuccess: onSuccess, onError: onError)
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

                onSuccess?(RoomInfo(roomId: roomId, hostName: hostName, guestName: "", isOpen: true))
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

            guard let isOpen = room[FirebasePaths.rooms_roomId_isOpen] as? Bool,
                  let hostName = room[FirebasePaths.rooms_roomId_host] as? String else {
                onError?()
                return
            }

            if !isOpen {
                onRoomIsClosed?()
                return
            }

            // TODO: add guest player
            // TODO: check if we should close room immediately
            roomRef.child(FirebasePaths.rooms_roomId_isOpen).setValue(false as AnyObject)
            roomRef.child(FirebasePaths.rooms_roomId_guest).setValue(guestName as AnyObject)

            let roomInfo = RoomInfo(roomId: roomId,
                                    hostName: hostName,
                                    guestName: guestName,
                                    isOpen: false)

            onSuccess?(roomInfo)
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

            guard let updatedRoomInfo = RoomInfo.getRoomInfoFirebase(roomId: roomId, from: room) else {
                onError?()
                print("error getting updated room info")
                return
            }
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

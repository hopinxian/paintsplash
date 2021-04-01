//
//  FirebaseConnectionHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.
//

import Firebase

class FirebaseLobbyHandler: LobbyHandler {
    var connectionHandler: ConnectionHandler

    init(connectionHandler: ConnectionHandler) {
        self.connectionHandler = connectionHandler
    }

    func createRoom(player: PlayerInfo, onSuccess: ((RoomInfo) -> Void)?, onError: ((Error?) -> Void)?) {
        // Generate unique room code to return to player
        let roomId = randomFourCharString()
        let roomPath = FirebasePaths.joinPaths(FirebasePaths.rooms, roomId)
        connectionHandler.getData(at: roomPath) { [weak self] error, roomInfo in
            // Room already exists, try creating another one
            if roomInfo != nil {
                self?.createRoom(player: player, onSuccess: onSuccess, onError: onError)
                return
            }

            let newRoomInfo = RoomInfo(roomId: roomId, host: player, players: [:], isOpen: true)
            self?.connectionHandler.send(
                to: roomPath,
                data: newRoomInfo,
                mode: .single,
                shouldRemoveOnDisconnect: true,
                onComplete: { onSuccess?(newRoomInfo) },
                onError: onError
            )
        }
//        roomRef.observeSingleEvent(of: .value, with: { [weak self] snapshot in
//
//            // Room already exists, try creating another one
//            if snapshot.value as? [String: AnyObject] != nil {
//                self?.createRoom(player: player, onSuccess: onSuccess, onError: onError)
//                return
//            }
//
//            let hostId = player.playerUUID
//
//            let playerDict = player.toPlayerDict()
//            let players = [hostId: playerDict]
//
//            var roomInfo: [String: AnyObject] = [:]
//            roomInfo[FirebasePaths.rooms_isOpen] = true as AnyObject
//            roomInfo[FirebasePaths.rooms_id] = roomId as AnyObject
//            roomInfo[FirebasePaths.rooms_players] = players as AnyObject
//
//            roomRef.setValue(roomInfo, withCompletionBlock: { error, ref in
//                if let error = error {
//                    onError?(error)
//                    return
//                }
//
//                ref.onDisconnectRemoveValue()
//
//                // TODO
//                onSuccess?(RoomInfo(from: roomInfo))
//            })
//        })
    }

    private func randomFourCharString() -> String {
        var string = ""
        for _ in 0..<4 {
            string += String(Int.random(in: 0...9))
        }
        return string
    }

    func joinRoom(player: PlayerInfo, roomId: String, onSuccess: ((RoomInfo) -> Void)?,
                  onError: ((Error?) -> Void)?, onRoomIsClosed: (() -> Void)?,
                  onRoomNotExist: (() -> Void)?) {
        print("Try to join room \(roomId)")
        // Try to join a room
        let roomPath = FirebasePaths.rooms + "/" + roomId
        connectionHandler.getData(at: roomPath, block: { (error: Error?, roomInfo: RoomInfo?) in
            guard let roomInfo = roomInfo else {
                onRoomNotExist?()
                return
            }

            if !roomInfo.isOpen {
                onRoomIsClosed?()
                return
            }
            // TODO: check if we should close room immediately

            let players = roomInfo.players ?? [:]
            // check that player doesn't already exist
            guard players[player.playerUUID] == nil else {
                print("player already exists")
                onError?(nil)
                return
            }

            // Add guest as one of the players
            var newRoomInfo = roomInfo
            newRoomInfo.players = [:]
            newRoomInfo.players?[player.playerUUID] = player
            let roomPath = FirebasePaths.joinPaths(FirebasePaths.rooms, roomId, FirebasePaths.rooms_players,
                                                   player.playerUUID)
            self.connectionHandler.send(
                to: roomPath,
                data: player,
                mode: .single, shouldRemoveOnDisconnect: true,
                onComplete: { onSuccess?(newRoomInfo) },
                onError: onError
            )
        })
    }

    func observeRoom(roomId: String, onRoomChange: ((RoomInfo) -> Void)?, onRoomClose: (() -> Void)?,
                     onError: ((Error?) -> Void)?) {
        let roomPath = FirebasePaths.joinPaths(FirebasePaths.rooms, roomId)
        connectionHandler.listen(to: roomPath) { (roomInfo: RoomInfo?) in
            guard let roomInfo = roomInfo else {
                onRoomClose?()
                return
            }
            onRoomChange?(roomInfo)
        }
    }

    func leaveRoom(roomId: String, onSuccess: (() -> Void)?, onError: ((Error?) -> Void)?) {
        // TODO: check if player is host
    }

    func startGame(roomInfo: RoomInfo) {
        var newRoomInfo = roomInfo
        newRoomInfo.started = true
        newRoomInfo.gameID = UUID().uuidString
        let roomPath = FirebasePaths.rooms + "/" + newRoomInfo.roomId
        connectionHandler.send(to: roomPath, data: newRoomInfo, mode: .single, shouldRemoveOnDisconnect: false, onComplete: nil, onError: nil)
    }

    func getAllRooms() {
        connectionHandler.getData(at: FirebasePaths.rooms) { (error, snapshot) in
            if let error = error {
                print("Error fetching all rooms \(error)")
                return
            }
            print("Fetched all rooms: \(snapshot)")
        }
    }

    func startGame(roomId: String, player: PlayerInfo, onSuccess: ((RoomInfo) -> Void)?,
                   onError: ((Error?) -> Void)?) {
        let roomPath = FirebasePaths.joinPaths(FirebasePaths.rooms, roomId)

        // create and set a room ID
        connectionHandler.getData(at: roomPath, block: { (error: Error?, roomInfo: RoomInfo?) in
            guard var roomInfo = roomInfo else {
                print("Room does not exist anymore")
                return
            }

            // Check if player starting game is host
            if player != roomInfo.host {
                print("player is not host and cannot start game")
                return
            }

            guard roomInfo.players != nil else {
                print("Insufficient players to start multiplayer game")
                return
            }

            // Generate UUID for new game
            let newGameId = UUID().uuidString

            // Create a new game entry
            let gamePath = FirebasePaths.joinPaths(FirebasePaths.games, newGameId)
            let newGame = GameStateInfo(roomId: roomId, gameId: newGameId)

            self.connectionHandler.send(to: gamePath,
                                        data: newGame,
                                        mode: .single, shouldRemoveOnDisconnect: true,
                                        onComplete: nil,
                                        onError: onError)

            // Update game state for room
            roomInfo.gameID = newGameId
            roomInfo.started = true
            roomInfo.closeGame()
            let roomGamePath = FirebasePaths.joinPaths(roomPath)
            self.connectionHandler.send(to: roomGamePath,
                                        data: roomInfo,
                                        mode: .single, shouldRemoveOnDisconnect: true,
                                        onComplete: { onSuccess?(roomInfo) },
                                        onError: onError)

            print("successfully set game ID")
        })
    }

}

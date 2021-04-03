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
            guard error == nil else {
                onError?(error)
                return
            }

            // Room already exists, try creating another one
            guard roomInfo == nil else {
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
    }

    private func randomFourCharString() -> String {
        var string = ""
        for _ in 0..<4 {
            string += String(Int.random(in: 0...9))
        }
        return string
    }

    func joinRoom(
        player: PlayerInfo,
        roomId: String,
        onSuccess: ((RoomInfo) -> Void)?,
        onError: ((Error?) -> Void)?, onRoomIsClosed: (() -> Void)?,
        onRoomNotExist: (() -> Void)?
    ) {
        // Try to join a room
        let roomPath = FirebasePaths.joinPaths(FirebasePaths.rooms, roomId)

        connectionHandler.getData(at: roomPath, block: { [weak self] (error: Error?, roomInfo: RoomInfo?) in
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
                print("Player already exists")
                onError?(nil)
                return
            }

            // Add guest as one of the players
            var newRoomInfo = roomInfo
            newRoomInfo.players = [:]
            newRoomInfo.players?[player.playerUUID] = player
            let roomPath = FirebasePaths.joinPaths(FirebasePaths.rooms, roomId,
                                                   FirebasePaths.rooms_players, player.playerUUID)
            self?.connectionHandler.send(
                to: roomPath,
                data: player,
                mode: .single, shouldRemoveOnDisconnect: true,
                onComplete: { onSuccess?(newRoomInfo) },
                onError: onError
            )
        })
    }

    func observeRoom(
        roomId: String,
        onRoomChange: ((RoomInfo) -> Void)?,
        onRoomClose: (() -> Void)?,
        onError: ((Error?) -> Void)?
    ) {
        let roomPath = FirebasePaths.joinPaths(FirebasePaths.rooms, roomId)

        connectionHandler.listen(to: roomPath) { (roomInfo: RoomInfo?) in
            guard let roomInfo = roomInfo else {
                onRoomClose?()
                return
            }
            onRoomChange?(roomInfo)
        }
    }

    func leaveRoom(
        playerInfo: PlayerInfo,
        roomId: String,
        onSuccess: (() -> Void)?,
        onError: ((Error?) -> Void)?
    ) {
        let roomPath = FirebasePaths.joinPaths(FirebasePaths.rooms, roomId)

        connectionHandler.getData(at: roomPath, block: { [weak self] (error: Error?, roomInfo: RoomInfo?) in
            guard let roomInfo = roomInfo else {
                onError?(error)
                return
            }

            // If player is host: remove room
            if roomInfo.host == playerInfo {
                self?.connectionHandler.removeData(at: roomPath, block: { error in
                    if error != nil {
                        print("host leave room error")
                        onError?(error)
                        return
                    }
                    print("Player was host and closed room")
                    onSuccess?()
                    return
                })
            }

            // If player is guest:
            let playerPath = FirebasePaths.joinPaths(roomPath, FirebasePaths.game_players, playerInfo.playerUUID)
            self?.connectionHandler.removeData(at: playerPath, block: { error in
                if error != nil {
                    print("guest leave room error")
                    onError?(error)
                    return
                }
                print("Player was guest and left room")
                let roomIsOpenPath = FirebasePaths.joinPaths(roomPath, FirebasePaths.rooms_isOpen)
                self?.connectionHandler.sendSingleValue(to: roomIsOpenPath, data: true,
                                                        shouldRemoveOnDisconnect: false,
                                                        onComplete: onSuccess, onError: onError)
            })
        })
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

    func startGame(
        roomId: String,
        player: PlayerInfo,
        onSuccess: ((RoomInfo) -> Void)?,
        onError: ((Error?) -> Void)?
    ) {
        let roomPath = FirebasePaths.joinPaths(FirebasePaths.rooms, roomId)

        connectionHandler.getData(at: roomPath, block: { [weak self] (error: Error?, roomInfo: RoomInfo?) in
            guard var roomInfo = roomInfo else {
                print("Room does not exist anymore")
                return
            }

            // Check if player starting game is host
            if player != roomInfo.host {
                print("player is not host and cannot start game")
                return
            }

//            guard roomInfo.players != nil else {
//                // TODO: handle UI for this
//                print("Insufficient players to start multiplayer game")
//                return
//            }

            // Generate UUID for new game
            let newGameId = UUID().uuidString

            // Create a new game entry
            let gamePath = FirebasePaths.joinPaths(FirebasePaths.games, newGameId)
            let newGame = GameStateInfo(roomId: roomId, gameId: newGameId, isRunning: true)

            self?.connectionHandler.send(to: gamePath,
                                         data: newGame,
                                         mode: .single, shouldRemoveOnDisconnect: true,
                                         onComplete: nil,
                                         onError: onError)

            // Update game state for room
            roomInfo.gameID = newGameId
            roomInfo.started = true
            roomInfo.closeGame()
            let roomGamePath = FirebasePaths.joinPaths(roomPath)
            self?.connectionHandler.send(
                to: roomGamePath,
                data: roomInfo,
                mode: .single, shouldRemoveOnDisconnect: true,
                onComplete: { onSuccess?(roomInfo) },
                onError: onError
            )
        })
    }

    func stopGame(roomInfo: RoomInfo, onSuccess: (() -> Void)?, onError: ((Error?) -> Void)?) {
        let gamePath = FirebasePaths.joinPaths(FirebasePaths.games, roomInfo.gameID)
        let gameRunningPath = FirebasePaths.joinPaths(FirebasePaths.games, roomInfo.gameID,
                                                      FirebasePaths.game_isRunning)

        func changeGameStatus() {
            let gameStartedPath = FirebasePaths.joinPaths(FirebasePaths.rooms, roomInfo.roomId,
                                                          FirebasePaths.rooms_gameStarted)
            self.connectionHandler.sendSingleValue(to: gameStartedPath,
                                                   data: false,
                                                   shouldRemoveOnDisconnect: false,
                                                   onComplete: {
                                                    print("changed game status")
                                                    onSuccess?()
                                                   },
                                                   onError: onError)
        }

        connectionHandler.sendSingleValue(to: gameRunningPath, data: false,
                                          shouldRemoveOnDisconnect: false,
                                          onComplete: { [weak self] in
                                            self?.connectionHandler.removeData(at: gamePath, block: { error in
                                                if error != nil {
                                                    onError?(error)
                                                    return
                                                }
                                                print("stopped game, removed game data")
                                                changeGameStatus()
                                            })
                                          }, onError: onError)
    }

    func observeGame(roomInfo: RoomInfo, onGameStop: (() -> Void)?, onError: ((Error?) -> Void)?) {
        let gameRunningPath = FirebasePaths.joinPaths(FirebasePaths.games, roomInfo.gameID,
                                                      FirebasePaths.game_isRunning)
        connectionHandler.observeSingleValue(to: gameRunningPath, callBack: { (isRunning: Bool?) in
            guard let isRunning = isRunning else {
                return
            }
            if !isRunning {
                onGameStop?()
            }
        })
    }
}

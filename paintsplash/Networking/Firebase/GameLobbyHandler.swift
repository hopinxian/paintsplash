//
//  FirebaseConnectionHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.
// swiftlint:disable function_parameter_count closure_body_length

import Firebase

class GameLobbyHandler: LobbyHandler {
    var connectionHandler: ConnectionHandler

    init(connectionHandler: ConnectionHandler) {
        self.connectionHandler = connectionHandler
    }

    func createRoom(player: PlayerInfo, onSuccess: ((RoomInfo) -> Void)?, onError: ((Error?) -> Void)?) {
        // Generate unique room code to return to player
        let roomId = randomFourCharString()
        let roomPath = DataPaths.joinPaths(DataPaths.rooms, roomId)
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
            print("creating new room")
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
        let roomPath = DataPaths.joinPaths(DataPaths.rooms, roomId)

        connectionHandler.getData(at: roomPath, callback: { [weak self] (_: Error?, roomInfo: RoomInfo?) in
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
            let roomPath = DataPaths.joinPaths(
                DataPaths.rooms, roomId,
                DataPaths.rooms_players, player.playerUUID
            )

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
        let roomPath = DataPaths.joinPaths(DataPaths.rooms, roomId)

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
        let roomPath = DataPaths.joinPaths(DataPaths.rooms, roomId)

        connectionHandler.getData(at: roomPath, callback: { [weak self] (error: Error?, roomInfo: RoomInfo?) in
            guard let roomInfo = roomInfo else {
                onError?(error)
                return
            }

            // If player is host: remove room
            if roomInfo.host == playerInfo {
                self?.connectionHandler.removeData(at: roomPath, callBack: { error in
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
            let playerPath = DataPaths.joinPaths(roomPath, DataPaths.game_players, playerInfo.playerUUID)
            self?.connectionHandler.removeData(at: playerPath, callBack: { error in
                if error != nil {
                    print("guest leave room error")
                    onError?(error)
                    return
                }
                print("Player was guest and left room")
                let roomIsOpenPath = DataPaths.joinPaths(roomPath, DataPaths.rooms_isOpen)
                self?.connectionHandler.sendSingleValue(to: roomIsOpenPath, data: true,
                                                        shouldRemoveOnDisconnect: false,
                                                        onComplete: onSuccess, onError: onError)
            })
        })
    }

    func getAllRooms() {
        connectionHandler.getData(at: DataPaths.rooms) { error, _ in
            if let err = error {
                print("Error fetching all rooms \(err)")
                return
            }
        }
    }

    func startGame(
        roomId: String,
        player: PlayerInfo,
        onSuccess: ((RoomInfo) -> Void)?,
        onError: ((Error?) -> Void)?
    ) {
        let roomPath = DataPaths.joinPaths(DataPaths.rooms, roomId)

        connectionHandler.getData(at: roomPath, callback: { [weak self] (_: Error?, roomInfo: RoomInfo?) in
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
                // TODO: handle UI for this, condition unreachable
                print("Insufficient players to start multiplayer game")
                return
            }

            // Generate UUID for new game
            let newGameId = UUID().uuidString

            // Create a new game entry
            let gamePath = DataPaths.joinPaths(DataPaths.games, newGameId)
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
            let roomGamePath = DataPaths.joinPaths(roomPath)
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
        let gamePath = DataPaths.joinPaths(DataPaths.games, roomInfo.gameID)
        let gameRunningPath = DataPaths.joinPaths(DataPaths.games, roomInfo.gameID,
                                                  DataPaths.game_isRunning)

        func changeGameStatus() {
            let gameStartedPath = DataPaths.joinPaths(
                DataPaths.rooms, roomInfo.roomId,
                DataPaths.rooms_gameStarted
            )

            self.connectionHandler.sendSingleValue(
                to: gameStartedPath,
                data: false,
                shouldRemoveOnDisconnect: false,
                onComplete: {
                    print("changed game status")
                    onSuccess?()
                },
                onError: onError
            )
        }

        connectionHandler.sendSingleValue(
            to: gameRunningPath, data: false,
            shouldRemoveOnDisconnect: false,
            onComplete: { [weak self] in
                self?.connectionHandler.removeData(at: gamePath, callBack: { error in
                    if error != nil {
                        onError?(error)
                        return
                    }
                    print("stopped game, removed game data")
                    changeGameStatus()
                })
            }, onError: onError
        )
    }

    func observeGame(roomInfo: RoomInfo, onGameStop: (() -> Void)?, onError: ((Error?) -> Void)?) {
        let gameRunningPath = DataPaths.joinPaths(
            DataPaths.games, roomInfo.gameID,
            DataPaths.game_isRunning
        )
        connectionHandler.listenToSingleValue(to: gameRunningPath, callBack: { (isRunning: Bool?) in
            guard let isRunning = isRunning else {
                return
            }
            if !isRunning {
                onGameStop?()
            }
        })
    }
}

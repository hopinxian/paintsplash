//
//  FirebaseConnectionHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.

import Firebase

class GameLobbyHandler: LobbyHandler {
    var connectionHandler: ConnectionHandler

    init(connectionHandler: ConnectionHandler) {
        self.connectionHandler = connectionHandler
    }

    /// Creates a room with a unique 4-digit ID code for another user to join in Multiplayer mode
    func createRoom(player: PlayerInfo, onSuccess: ((RoomInfo) -> Void)?, onError: ((Error?) -> Void)?) {
        // Generate unique room code
        let roomId = randomFourDigitString()

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

            // Create and write new room information to database
            let newRoomInfo = RoomInfo(roomId: roomId, host: player, players: [:], isOpen: true)
            self?.connectionHandler.send(
                to: roomPath,
                data: newRoomInfo,
                shouldRemoveOnDisconnect: true,
                onComplete: { onSuccess?(newRoomInfo) },
                onError: onError
            )
        }
    }

    private func randomFourDigitString() -> String {
        var string = ""
        for _ in 0..<4 {
            string += String(Int.random(in: 0...9))
        }
        return string
    }

    /// Allows a player to join an existing room in Multiplayer mode
    func joinRoom(player: PlayerInfo, roomId: String,
                  onSuccess: ((RoomInfo) -> Void)?, onError: ((Error?) -> Void)?,
                  onRoomIsClosed: (() -> Void)?, onRoomNotExist: (() -> Void)?) {

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

            guard let newRoomInfo = self?.addPlayerToRoomInfo(room: roomInfo, player: player) else {
                onError?(nil)
                return
            }

            let roomPlayerPath = DataPaths.joinPaths(roomPath, DataPaths.rooms_players, player.playerUUID)

            self?.connectionHandler.send(
                to: roomPlayerPath,
                data: player,
                shouldRemoveOnDisconnect: true,
                onComplete: { onSuccess?(newRoomInfo) },
                onError: onError
            )
        })
    }

    private func addPlayerToRoomInfo(room: RoomInfo, player: PlayerInfo) -> RoomInfo? {
        let players = room.players ?? [:]

        // Check that player doesn't already exist in room
        guard players[player.playerUUID] == nil else {
            return nil
        }

        // Add guest as one of the players and close game
        var newRoomInfo = room
        newRoomInfo.players = [:]
        newRoomInfo.players?[player.playerUUID] = player
        newRoomInfo.closeGame()

        return newRoomInfo
    }

    /// Observe the room for any changes in state and invoke the relevant callbacks
    func observeRoom(roomId: String, onRoomChange: ((RoomInfo) -> Void)?,
                     onRoomClose: (() -> Void)?, onError: ((Error?) -> Void)?) {
        let roomPath = DataPaths.joinPaths(DataPaths.rooms, roomId)

        connectionHandler.listen(to: roomPath) { (roomInfo: RoomInfo?) in
            // If room no longer exists
            guard let roomInfo = roomInfo else {
                onRoomClose?()
                return
            }

            // If room still exists and has changed
            onRoomChange?(roomInfo)
        }
    }

    /// Allows a player to leave the room
    /// If the leaving player is the room's host, the room is removed from the database
    /// If the leaving player is a guest, the player's info is erased and the room's status is set to open
    func leaveRoom(playerInfo: PlayerInfo, roomId: String,
                   onSuccess: (() -> Void)?, onError: ((Error?) -> Void)?) {

        let roomPath = DataPaths.joinPaths(DataPaths.rooms, roomId)

        // Fetch room information from database
        connectionHandler.getData(at: roomPath, callback: { [weak self] (error: Error?, roomInfo: RoomInfo?) in
            guard let roomInfo = roomInfo else {
                onError?(error)
                return
            }

            if roomInfo.host == playerInfo {
                self?.handleHostLeaveRoom(roomPath: roomPath, onSuccess: onSuccess, onError: onError)
                return
            }

            // Player leaving the room is a guest
            self?.handleGuestLeaveRoom(roomPath: roomPath, guestInfo: playerInfo,
                                       onSuccess: onSuccess, onError: onError)
        })
    }

    private func handleHostLeaveRoom(roomPath: String, onSuccess: (() -> Void)?, onError: ((Error?) -> Void)?) {
        // Remove room information upon host leaving
        self.connectionHandler.removeData(at: roomPath, callBack: { error in
            if error != nil {
                onError?(error)
                return
            }
            onSuccess?()
            return
        })
    }

    private func handleGuestLeaveRoom(roomPath: String, guestInfo: PlayerInfo,
                                      onSuccess: (() -> Void)?, onError: ((Error?) -> Void)?) {

        let playerPath = DataPaths.joinPaths(roomPath, DataPaths.game_players, guestInfo.playerUUID)

        // Remove player information from room
        self.connectionHandler.removeData(at: playerPath, callBack: { [weak self] error in
            guard error == nil else {
                onError?(error)
                return
            }
            // Set room status to open once player has left
            self?.changeRoomOpenStatus(roomPath: roomPath, isOpen: true,
                                       onSuccess: onSuccess, onError: onError)

        })
    }

    private func changeRoomOpenStatus(roomPath: String, isOpen: Bool,
                                      onSuccess: (() -> Void)?, onError: ((Error?) -> Void)?) {
        let roomIsOpenPath = DataPaths.joinPaths(roomPath, DataPaths.rooms_isOpen)
        self.connectionHandler.sendSingleValue(to: roomIsOpenPath,
                                               data: true,
                                               shouldRemoveOnDisconnect: false,
                                               onComplete: onSuccess, onError: onError)
    }

    /// Allows a host player to start the game for both the host and guest
    func startGame(roomId: String, player: PlayerInfo,
                   onSuccess: ((RoomInfo) -> Void)?, onError: ((Error?) -> Void)? ) {

        let roomPath = DataPaths.joinPaths(DataPaths.rooms, roomId)

        connectionHandler.getData(at: roomPath, callback: { [weak self] (_: Error?, roomInfo: RoomInfo?) in
            guard let roomInfo = roomInfo,
                  let canStartGame = self?.canStartGame(roomInfo: roomInfo, player: player),
                  canStartGame else {
                onError?(nil)
                return
            }

            // Generate UUID for new game
            let newGameId = UUID().uuidString

            // Create a new game entry
            let gamePath = DataPaths.joinPaths(DataPaths.games, newGameId)
            let newGame = GameStateInfo(roomId: roomId, gameId: newGameId, isRunning: true)

            self?.connectionHandler.send(to: gamePath,
                                         data: newGame,
                                         shouldRemoveOnDisconnect: true,
                                         onComplete: nil,
                                         onError: { error in
                                            onError?(error)
                                            return
                                         })

            // Update game state for room
            self?.updateGameStartedForRoom(roomInfo: roomInfo, newGameId: newGameId,
                                           onSuccess: onSuccess, onError: onError)
        })
    }

    private func canStartGame(roomInfo: RoomInfo, player: PlayerInfo) -> Bool {
        player == roomInfo.host && roomInfo.players != nil
    }

    private func updateGameStartedForRoom(roomInfo: RoomInfo,
                                          newGameId: String,
                                          onSuccess: ((RoomInfo) -> Void)?,
                                          onError: ((Error?) -> Void)?) {

        let roomPath = DataPaths.joinPaths(DataPaths.rooms, roomInfo.roomId)

        var updatedRoomInfo = roomInfo
        updatedRoomInfo.gameID = newGameId
        updatedRoomInfo.started = true
        updatedRoomInfo.closeGame()

        self.connectionHandler.send(
            to: roomPath,
            data: updatedRoomInfo,
            shouldRemoveOnDisconnect: true,
            onComplete: { onSuccess?(updatedRoomInfo) },
            onError: onError
        )
    }

    /// Ends the game for both the host and the guest
    func stopGame(roomInfo: RoomInfo, onSuccess: (() -> Void)?, onError: ((Error?) -> Void)?) {
        let gamePath = DataPaths.joinPaths(DataPaths.games, roomInfo.gameID)
        let gameRunningPath = DataPaths.joinPaths(gamePath, DataPaths.game_isRunning)

        connectionHandler.sendSingleValue(
            to: gameRunningPath,
            data: false,
            shouldRemoveOnDisconnect: false,
            onComplete: { [weak self] in
                self?.removeGameData(roomInfo: roomInfo, gamePath: gamePath,
                                     onSuccess: onSuccess, onError: onError)
            }, onError: onError
        )
    }

    private func removeGameData(roomInfo: RoomInfo, gamePath: String,
                                onSuccess: (() -> Void)?, onError: ((Error?) -> Void)?) {
        self.connectionHandler.removeData(at: gamePath, callBack: { [weak self] error in
            if error != nil {
                onError?(error)
                return
            }
            self?.changeGameStarted(roomInfo: roomInfo, gameStarted: false,
                                    onSuccess: onSuccess, onError: onError)
        })
    }

    private func changeGameStarted(roomInfo: RoomInfo, gameStarted: Bool,
                                   onSuccess: (() -> Void)?, onError: ((Error?) -> Void)?) {
        let gameStartedPath = DataPaths.joinPaths(
            DataPaths.rooms, roomInfo.roomId,
            DataPaths.rooms_gameStarted
        )
        self.connectionHandler.sendSingleValue(
            to: gameStartedPath,
            data: gameStarted,
            shouldRemoveOnDisconnect: false,
            onComplete: {
                onSuccess?()
            },
            onError: onError
        )
    }

    /// Observer game information for a given room
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

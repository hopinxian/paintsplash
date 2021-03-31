//
//  ConnectionHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.
//

protocol LobbyHandler {
    func createRoom(player: PlayerInfo,
                    onSuccess: ((RoomInfo) -> Void)?,
                    onError: ((Error?) -> Void)?)

    func getAllRooms()

    func joinRoom(player: PlayerInfo,
                  roomId: String,
                  onSuccess: ((RoomInfo) -> Void)?,
                  onError: ((Error?) -> Void)?,
                  onRoomIsClosed: (() -> Void)?,
                  onRoomNotExist: (() -> Void)?)

    func observeRoom(roomId: String,
                     onRoomChange: ((RoomInfo) -> Void)?,
                     onRoomClose: (() -> Void)?,
                     onError: ((Error?) -> Void)?)

    func leaveRoom(roomId: String,
                   onSuccess: (() -> Void)?,
                   onError: ((Error?) -> Void)?)

    func startGame(roomInfo: RoomInfo)

}

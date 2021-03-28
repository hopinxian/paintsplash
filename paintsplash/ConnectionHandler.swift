//
//  ConnectionHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.
//

protocol ConnectionHandler {
    func createRoom(hostName: String,
                    onSuccess: ((String) -> Void)?,
                    onError: ((Error) -> Void)?)

    func joinRoom(guestName: String,
                  roomId: String,
                  onSuccess: (() -> Void)?,
                  onRoomNotExist: (() -> Void)?)

    func leaveRoom(roomId: String,
                   onSuccess: (() -> Void)?,
                   onError: ((Error) -> Void)?)

}

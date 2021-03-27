//
//  ConnectionHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 27/3/21.
//

protocol ConnectionHandler {
    func createRoom(hostName: String)

    func joinRoom(hostName: String)
}

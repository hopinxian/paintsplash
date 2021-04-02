//
//  GameConnectionHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 30/3/21.
//
import Foundation

protocol GameConnectionHandler {
    func sendPlayerEvent<T: Codable>(gameId: String, playerId: String, action: T) where T: Event

    func observePlayerEvent<T: Codable>(gameId: String, playerId: String, onChange: ((T) -> Void)?) where T: Event
}

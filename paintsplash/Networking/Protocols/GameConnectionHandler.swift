//
//  GameConnectionHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 30/3/21.
//
import Foundation

protocol GameConnectionHandler {
    func sendEvent<T: Codable>(
        gameId: String,
        playerId: String,
        action: T
    ) where T: Event

    func observeEvent<T: Codable>(
        gameId: String,
        playerId: String,
        onChange: ((T) -> Void)?
    ) where T: Event

    func acknowledgeEvent<T: Codable>(
        _ event: T,
        gameId: String,
        playerId: String
    ) where T: Event
}

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
        action: T,
        onError: ((Error?) -> Void)?,
        onSuccess: (() -> Void)?
    ) where T: Event

    func observeEvent<T: Codable>(
        gameId: String,
        playerId: String,
        onChange: ((T) -> Void)?,
        onError: ((Error?) -> Void)?
    ) where T: Event

    func acknowledgeEvent<T: Codable>(
        _ event: T,
        gameId: String,
        playerId: String,
        onError: ((Error?) -> Void)?,
        onSuccess: (() -> Void)?
    ) where T: Event

    func sendSystemData(data: SystemData, gameID: String)
    func observeSystemData(gameID: String, callback: @escaping (SystemData?) -> Void)
}

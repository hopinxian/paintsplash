//
//  MPServerNetworkHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 18/4/21.
//

protocol MPServerNetworkHandler {
    func sendGameState()

    func setupPlayerEventSenders(player: PlayerInfo, gameId: String)

    func setupPlayerEventObservers(player: PlayerInfo, gameId: String)

    func setupClientPlayer(player: PlayerInfo, gameId: String)
}

extension MPServerNetworkHandler {
    func setupClientPlayer(player: PlayerInfo, gameId: String) {
        setupPlayerEventObservers(player: player, gameId: gameId)
        setupPlayerEventSenders(player: player, gameId: gameId)
    }
}

//
//  MPClientNetworkHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 18/4/21.
//

protocol MPClientNetworkHandler {
    var multiplayerClient: MultiplayerClient? { get set }

    func setupPlayerInputSenders()

    func setupPlayerEventObservers(player: PlayerInfo)
}

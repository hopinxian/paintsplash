//
//  MPServerNetworkHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 18/4/21.
//

protocol MPServerNetworkHandler {
    func sendGameState(uiEntities: Set<GameEntity>, entities: Set<GameEntity>,
                       renderSystem: RenderSystem, animationSystem: AnimationSystem)

    func setupPlayerEventSenders(player: PlayerInfo)

    func setupPlayerEventObservers(player: PlayerInfo)

    func setupClientPlayer(player: PlayerInfo)

    func setUpGameEventSenders()

    func sendGameOverEvent(event: GameOverEvent, playerInfo: PlayerInfo)
}

extension MPServerNetworkHandler {
    func setupClientPlayer(player: PlayerInfo) {
        setupPlayerEventObservers(player: player)
        setupPlayerEventSenders(player: player)
    }
}

//
//  MultiplayerServerNetworkManager.swift
//  paintsplash
//
//  Created by Cynthia Lee on 18/4/21.
//

import Foundation

class FirebaseMPServerNetworkHandler: MPServerNetworkHandler {
    var connectionHandler = FirebaseConnectionHandler()
    var gameConnectionHandler: GameConnectionHandler =
        PaintSplashGameHandler(connectionHandler: FirebaseConnectionHandler())

    let gameId: String

    init(gameId: String) {
        self.gameId = gameId
    }

    func sendGameState(uiEntities: Set<GameEntity>, entities: Set<GameEntity>,
                       renderSystem: RenderSystem, animationSystem: AnimationSystem) {
        sendGameStateToDatabase(uiEntities: uiEntities, entities: entities,
                                renderSystem: renderSystem, animationSystem: animationSystem)
    }

    /// Allow the server to send player events to the database for clients to observe
    func setupPlayerEventSenders(player: PlayerInfo) {
        let playerId = EntityID(id: player.playerUUID)
        setupPlayerAmmoSender(playerId, gameId)
        setupPlayerWeaponSender(playerId, gameId)
        setupPlayerStateSender(playerId, gameId)
    }

    func setupPlayerEventObservers(player: PlayerInfo) {
        let playerId = EntityID(id: player.playerUUID).id
        observeClientMoveEvent(playerId: playerId, gameId: gameId)
        observeClientShootEvent(playerId: playerId, gameId: gameId)
        observeClientChangeWeaponEvent(playerId: playerId, gameId: gameId)
    }
}

// MARK: Client event senders
extension FirebaseMPServerNetworkHandler {
    private func setupPlayerStateSender(_ playerID: EntityID, _ gameId: String) {
        // Send player state (health) updates to DB
        let playerHealthUpdateEvent = EventSystem.playerActionEvent.playerHealthUpdateEvent

        playerHealthUpdateEvent.subscribe(listener: { [weak self] event in
            guard event.playerId == playerID else {
                return
            }
            self?.gameConnectionHandler.sendEvent(
                gameId: gameId,
                playerId: playerID.id,
                event: event,
                onError: nil,
                onSuccess: nil
            )
        })
    }

    private func setupPlayerWeaponSender(_ playerID: EntityID, _ gameId: String) {
        // Send player selected weapon updates to DB
        EventSystem.playerActionEvent.playerChangedWeaponEvent.subscribe(listener: { [weak self] event in
            guard event.playerId == playerID else {
                return
            }
            self?.gameConnectionHandler.sendEvent(
                gameId: gameId,
                playerId: playerID.id,
                event: event,
                onError: nil,
                onSuccess: nil
            )
        })
    }

    private func setupPlayerAmmoSender(_ playerID: EntityID, _ gameId: String) {
        // Update player ammo
        EventSystem.playerActionEvent.playerAmmoUpdateEvent.subscribe(listener: { [weak self] event in
            guard event.playerId == playerID else {
                return
            }
            self?.gameConnectionHandler.sendEvent(
                gameId: gameId,
                playerId: playerID.id,
                event: event,
                onError: nil,
                onSuccess: nil
            )
        })
    }
}

// MARK: Client event observers
extension FirebaseMPServerNetworkHandler {
    private func observeClientMoveEvent(playerId: String, gameId: String) {
        // Movement input
        self.gameConnectionHandler.observeEvent(
            gameId: gameId,
            playerId: playerId,
            onChange: { (event: PlayerMoveEvent) in
                EventSystem.processedInputEvents.playerMoveEvent.post(event: event)
            },
            onError: nil
        )
    }

    private func observeClientChangeWeaponEvent(playerId: String, gameId: String) {
        self.gameConnectionHandler.observeEvent(
            gameId: gameId,
            playerId: playerId,
            onChange: { (event: PlayerChangeWeaponEvent) in
                EventSystem.processedInputEvents.playerChangeWeaponEvent.post(event: event)
            },
            onError: nil
        )
    }

    private func observeClientShootEvent(playerId: String, gameId: String) {
        self.gameConnectionHandler.observeEvent(
            gameId: gameId,
            playerId: playerId,
            onChange: { (event: PlayerShootEvent) in
                EventSystem.processedInputEvents.playerShootEvent.post(event: event)
            },
            onError: nil
        )
    }

    private func observeClientData(playerId: String, gameId: String) {

    }

}

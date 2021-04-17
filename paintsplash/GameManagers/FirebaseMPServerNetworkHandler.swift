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

    func sendGameState() {
    }

    /// Allow the server to send player events to the database for clients to observe
    func setupPlayerEventSenders(player: PlayerInfo, gameId: String) {
        let playerId = EntityID(id: player.playerUUID)
        setupPlayerAmmoSender(playerId, gameId)
        setupPlayerWeaponSender(playerId, gameId)
        setupPlayerStateSender(playerId, gameId)
    }

    func setupPlayerEventObservers(player: PlayerInfo, gameId: String) {
        let playerId = EntityID(id: player.playerUUID).id
        self.gameConnectionHandler.observeEvent(
            gameId: gameId,
            playerId: playerId,
            onChange: { (event: PlayerShootEvent) in
                EventSystem.processedInputEvents.playerShootEvent.post(event: event)
            },
            onError: nil
        )

        // Movement input
        self.gameConnectionHandler.observeEvent(
            gameId: gameId,
            playerId: playerId,
            onChange: { (event: PlayerMoveEvent) in
                EventSystem.processedInputEvents.playerMoveEvent.post(event: event)
            },
            onError: nil
        )

        // Weapon change
        self.gameConnectionHandler.observeEvent(
            gameId: gameId,
            playerId: playerId,
            onChange: { (event: PlayerChangeWeaponEvent) in
                EventSystem.processedInputEvents.playerChangeWeaponEvent.post(event: event)
            },
            onError: nil
        )
    }

    private func setupPlayerStateSender(_ playerID: EntityID, _ gameId: String) {
        // Send player state updates to DB
        EventSystem.playerActionEvent.playerHealthUpdateEvent.subscribe(listener: { [weak self] event in
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
        EventSystem.playerActionEvent
            .playerChangedWeaponEvent.subscribe(listener: { [weak self] event in
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
        EventSystem.playerActionEvent
            .playerAmmoUpdateEvent.subscribe(listener: { [weak self] event in
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

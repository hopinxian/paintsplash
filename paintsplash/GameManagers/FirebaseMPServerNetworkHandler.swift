//
//  MultiplayerServerNetworkManager.swift
//  paintsplash
//
//  Created by Cynthia Lee on 18/4/21.
//

import Foundation

class FirebaseMPServerNetworkHandler: MPServerNetworkHandler {
    weak var multiplayerServer: MultiplayerServer?

    var connectionHandler = FirebaseConnectionHandler()
    var gameConnectionHandler: GameConnectionHandler =
        PaintSplashGameHandler(connectionHandler: FirebaseConnectionHandler())

    let gameId: String
    let roomInfo: RoomInfo

    init(roomInfo: RoomInfo) {
        self.roomInfo = roomInfo
        self.gameId = roomInfo.gameID
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

    func setupPlayerGameOverEventSender(player: PlayerInfo, level: Level?) {
        let playerId = EntityID(id: player.playerUUID)

        setupGameOverEventSender(playerId, gameId, level: level)
    }

    func setupPlayerEventObservers(player: PlayerInfo) {
        let playerId = EntityID(id: player.playerUUID).id
        observeClientMoveEvent(playerId: playerId, gameId: gameId)
        observeClientShootEvent(playerId: playerId, gameId: gameId)
        observeClientChangeWeaponEvent(playerId: playerId, gameId: gameId)

        observeClientData(playerId: playerId, gameId: gameId)
    }

    func setUpGameEventSenders() {
        setupMusicEventSender(gameId)
        setupSFXEventSender(gameId)
    }

    func sendGameOverEvent(event: GameOverEvent, playerInfo: PlayerInfo) {
        self.gameConnectionHandler.sendEvent(
            gameId: gameId,
            playerId: playerInfo.playerUUID,
            event: event,
            onError: nil,
            onSuccess: nil
        )
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

    private func setupGameOverEventSender(_ playerID: EntityID, _ gameId: String, level: Level?) {
        EventSystem.gameStateEvents.gameOverEvent.subscribe { [weak self] event in
            guard (self?.roomInfo.players) != nil else {
                return
            }
            event.score = level?.currentScore
            self?.gameConnectionHandler.sendEvent(
                gameId: gameId,
                playerId: playerID.id,
                event: event,
                onError: nil,
                onSuccess: nil
            )
        }
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
        let path = DataPaths.joinPaths(
            DataPaths.games, gameId,
            DataPaths.game_players, playerId,
            "clientPlayer")
        self.connectionHandler.listen(to: path, callBack: { [weak self] in
            self?.readClientPlayerData(data: $0)
        })
    }

    func readClientPlayerData(data: SystemData?) {
        guard let data = data,
              let entities = self.multiplayerServer?.entities else {
            return
        }

        let clientId = data.entityData.entities[0]
        if let client = entities.first(where: { $0.id.id == clientId.id }) as? Player,
            let transformComponent = data.renderSystemData?.renderables[clientId]?.transformComponent,
            let animationComponent = data.animationSystemData?.animatables[clientId]?.animationComponent,
            let renderComponent = data.renderSystemData?.renderables[clientId]?.renderComponent {
            let boundedComponent = BoundedTransformComponent(
                position: transformComponent.worldPosition,
                rotation: transformComponent.rotation,
                size: transformComponent.size,
                bounds: Constants.PLAYER_MOVEMENT_BOUNDS)
            client.transformComponent = boundedComponent
            client.renderComponent = renderComponent
            client.animationComponent = animationComponent
        }
    }

}

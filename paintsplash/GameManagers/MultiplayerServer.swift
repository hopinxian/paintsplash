//
//  MultiplayerServer.swift
//  paintsplash
//
//  Created by Farrell Nah on 28/3/21.
//
import Foundation

class MultiplayerServer: SinglePlayerGameManager {
    var room: RoomInfo
    var connectionHandler: ConnectionHandler
    var gameConnectionHandler: GameConnectionHandler?

    private var collisionDetector: SKCollisionDetector!

    init(roomInfo: RoomInfo, gameScene: GameScene, vc: GameViewController) {
        self.room = roomInfo
        let connectionHandler = FirebaseConnectionHandler()
        self.connectionHandler = connectionHandler
        self.gameConnectionHandler = PaintSplashGameHandler(connectionHandler: connectionHandler)

        super.init(gameScene: gameScene, vc: vc)
    }

    override func setUpPlayer() {
        let hostId = EntityID(id: room.host.playerUUID)

        player = Player(initialPosition: Vector2D.zero + Vector2D.right * 50, playerUUID: hostId)
        player.spawn()

        // set up other players
        room.players?.forEach { _, player in
            setUpGuestPlayer(player: player)
        }
    }

    func setUpGuestPlayer(player: PlayerInfo) {
        // Initialize player
        let playerID = EntityID(id: player.playerUUID)

        let gameId = self.room.gameID
        let newPlayer = Player(initialPosition: Vector2D.zero + Vector2D.left * 50, playerUUID: playerID)
        newPlayer.spawn()

        setupPlayerStateSender(playerID, gameId)
        setupPlayerWeaponSender(playerID, gameId)
        setupPlayerAmmoSender(playerID, gameId)
        setupMusicEventSender(gameId)
        setupSFXEventSender(gameId)
        setupGameOverEventSender(playerID: playerID, gameId)
        setupClientObservers(playerID: playerID, gameId: gameId)
    }

    private func setupPlayerStateSender(_ playerID: EntityID, _ gameId: String) {
        // Send player state updates to DB
        EventSystem.playerActionEvent
            .playerHealthUpdateEvent.subscribe(listener: { [weak self] event in
                guard event.playerId == playerID else {
                    return
                }
                self?.gameConnectionHandler?.sendEvent(
                    gameId: gameId,
                    playerId: playerID.id,
                    action: event,
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
                self?.gameConnectionHandler?.sendEvent(
                    gameId: gameId,
                    playerId: playerID.id,
                    action: event,
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
                self?.gameConnectionHandler?.sendEvent(
                    gameId: gameId,
                    playerId: playerID.id,
                    action: event,
                    onError: nil,
                    onSuccess: nil
                )
            })
    }

    private func setupMusicEventSender(_ gameId: String) {
        // Send background music information
        EventSystem.audioEvent.playMusicEvent.subscribe { [weak self] event in
            guard let players = self?.room.players else {
                return
            }

            guard let playerId = event.playerId else {
                players.forEach {
                    self?.gameConnectionHandler?.sendEvent(
                        gameId: gameId,
                        playerId: $0.key,
                        action: event,
                        onError: nil,
                        onSuccess: nil
                    )
                }
                return
            }

            self?.gameConnectionHandler?.sendEvent(
                gameId: gameId,
                playerId: playerId.id,
                action: event,
                onError: nil,
                onSuccess: nil
            )
        }
    }

    private func setupSFXEventSender(_ gameId: String) {
        EventSystem.audioEvent
            .playSoundEffectEvent.subscribe { [weak self] event in
                guard let players = self?.room.players else {
                    return
                }

                guard let playerId = event.playerId else {
                    players.forEach {
                        self?.gameConnectionHandler?.sendEvent(
                            gameId: gameId,
                            playerId: $0.key,
                            action: event,
                            onError: nil,
                            onSuccess: nil
                        )
                    }
                    return
                }

                self?.gameConnectionHandler?.sendEvent(
                    gameId: gameId,
                    playerId: playerId.id,
                    action: event,
                    onError: nil,
                    onSuccess: nil
                )
            }
    }

    private func setupGameOverEventSender(playerID: EntityID, _ gameId: String) {
        EventSystem.gameStateEvents
            .gameOverEvent.subscribe { [weak self] event in
                guard (self?.room.players) != nil else {
                    return
                }

                print("sending")
                event.score = self?.currentLevel?.score.score
                self?.gameConnectionHandler?.sendEvent(
                    gameId: gameId,
                    playerId: playerID.id,
                    action: event,
                    onError: nil,
                    onSuccess: nil
                )
            }
    }

    private func setupClientObservers(playerID: EntityID, gameId: String) {
        // Listen to user input from clients
        // Shooting input
        self.gameConnectionHandler?.observeEvent(
            gameId: gameId,
            playerId: playerID.id,
            onChange: { (event: PlayerShootEvent) in
                EventSystem.processedInputEvents.playerShootEvent.post(event: event)
            },
            onError: nil
        )

        // Movement input
        self.gameConnectionHandler?.observeEvent(
            gameId: gameId,
            playerId: playerID.id,
            onChange: { (event: PlayerMoveEvent) in
                EventSystem.processedInputEvents.playerMoveEvent.post(event: event)
            },
            onError: nil
        )

        // Weapon change
        self.gameConnectionHandler?.observeEvent(
            gameId: gameId,
            playerId: playerID.id,
            onChange: { (event: PlayerChangeWeaponEvent) in
                EventSystem.processedInputEvents.playerChangeWeaponEvent.post(event: event)
            },
            onError: nil
        )

        // player state observing
        let path = DataPaths.joinPaths(
            DataPaths.games, gameId,
            DataPaths.game_players, playerID.id,
            "clientPlayer")
        self.connectionHandler.listen(to: path, callBack: readClientPlayerData)
    }

    func sendGameState() {
        let uiEntityIDs = Set(uiEntities.map({ $0.id }))
        let entityData = EntityData(from: entities.filter({ !uiEntityIDs.contains($0.id) }))

        let renderablesToSend = renderSystem.wasModified.filter({ entityID, _ in
            !uiEntityIDs.contains(entityID)
        })

        let renderSystemData = RenderSystemData(from: renderablesToSend)

        let animatablesToSend = animationSystem.wasModified.filter({ entityID, _ in
            !uiEntityIDs.contains(entityID)
        })
        let animationSystemData = AnimationSystemData(from: animatablesToSend)

        var colorables = [EntityID: Colorable]()
        entities.forEach({ entity in
            if let colorable = entity as? Colorable, !uiEntityIDs.contains(entity.id) {
                colorables[entity.id] = colorable
            }
        })

        let colorSystemData = ColorSystemData(from: colorables)

        let systemData = SystemData(
            entityData: entityData,
            renderSystemData: renderSystemData,
            animationSystemData: animationSystemData,
            colorSystemData: colorSystemData
        )
        gameConnectionHandler?.sendSystemData(data: systemData, gameID: room.gameID)
    }

    override func update(_ deltaTime: Double) {
        if !gameIsOver {
            currentLevel?.update(deltaTime)
            aiSystem.updateEntities(deltaTime)
            collisionSystem.updateEntities(deltaTime)
            movementSystem.updateEntities(deltaTime)
            entities.forEach({ $0.update(deltaTime) })
            playerSystem.updateEntities(deltaTime)

            sendGameState()

            transformSystem.updateEntities(deltaTime)
            renderSystem.updateEntities(deltaTime)
            animationSystem.updateEntities(deltaTime)
        }
    }

    func readClientPlayerData(data: SystemData?) {
        guard let data = data else {
            return
        }
        let clientId = data.entityData.entities[0]
        if let client = entities.first(where: { $0.id.id == clientId.id }) as? Player,
           let transformComponent = data.renderSystemData?.renderables[clientId]?.transformComponent {
            let boundedComponent = BoundedTransformComponent(
                position: transformComponent.worldPosition,
                rotation: transformComponent.rotation,
                size: transformComponent.size,
                bounds: Constants.PLAYER_MOVEMENT_BOUNDS)
            client.transformComponent = boundedComponent
        }
    }
}

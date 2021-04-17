//
//  MultiplayerServer.swift
//  paintsplash
//
//  Created by Farrell Nah on 28/3/21.
//
import Foundation

class MultiplayerServer: SinglePlayerGameManager {
    var room: RoomInfo
    var connectionHandler = FirebaseConnectionHandler()
    var gameConnectionHandler: GameConnectionHandler =
        PaintSplashGameHandler(connectionHandler: FirebaseConnectionHandler())

    let networkHandler = FirebaseMPServerNetworkHandler()

    private var collisionDetector: SKCollisionDetector!

    init(roomInfo: RoomInfo, gameScene: GameScene, vc: GameViewController) {
        self.room = roomInfo
        super.init(gameScene: gameScene, vc: vc)
    }

    override func setUpPlayer() {
        let hostId = EntityID(id: room.host.playerUUID)

        player = Player(initialPosition: Vector2D.zero + Vector2D.right * 50, playerUUID: hostId)
        player.spawn()

        // Set up other players
        room.players?.forEach { _, player in
            setUpGuestPlayer(player: player)
        }
    }

    func setUpGuestPlayer(player: PlayerInfo) {
        // Initialize each guest player
        let playerID = EntityID(id: player.playerUUID)
        let newPlayer = Player(initialPosition: Vector2D.zero + Vector2D.left * 50, playerUUID: playerID)
        newPlayer.spawn()

        // Allow server to send player-related events to the database for clients to observe
        // and for server to listen to player-related events sent from client to update
        // game state
        let gameId = self.room.gameID
        // networkHandler.setupClientPlayer(player: player, gameId: gameId)
        networkHandler.setupPlayerEventSenders(player: player, gameId: gameId)

        setupMusicEventSender(gameId)
        setupSFXEventSender(gameId)

        setupGameOverEventSender(playerID: playerID, gameId)
        setupClientObservers(playerID: playerID, gameId: gameId)
    }

    private func setupMusicEventSender(_ gameId: String) {
        // Send background music information
        EventSystem.audioEvent.playMusicEvent.subscribe { [weak self] event in
            guard let players = self?.room.players else {
                return
            }

            guard let playerId = event.playerId else {
                players.forEach {
                    self?.gameConnectionHandler.sendEvent(
                        gameId: gameId,
                        playerId: $0.key,
                        event: event,
                        onError: nil,
                        onSuccess: nil
                    )
                }
                return
            }

            self?.gameConnectionHandler.sendEvent(
                gameId: gameId,
                playerId: playerId.id,
                event: event,
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
                        self?.gameConnectionHandler.sendEvent(
                            gameId: gameId,
                            playerId: $0.key,
                            event: event,
                            onError: nil,
                            onSuccess: nil
                        )
                    }
                    return
                }

                self?.gameConnectionHandler.sendEvent(
                    gameId: gameId,
                    playerId: playerId.id,
                    event: event,
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
                self?.gameConnectionHandler.sendEvent(
                    gameId: gameId,
                    playerId: playerID.id,
                    event: event,
                    onError: nil,
                    onSuccess: nil
                )
            }
    }

    private func setupClientObservers(playerID: EntityID, gameId: String) {
        // Listen to user input from clients
        // Shooting input
        self.gameConnectionHandler.observeEvent(
            gameId: gameId,
            playerId: playerID.id,
            onChange: { (event: PlayerShootEvent) in
                EventSystem.processedInputEvents.playerShootEvent.post(event: event)
            },
            onError: nil
        )

        // Movement input
        self.gameConnectionHandler.observeEvent(
            gameId: gameId,
            playerId: playerID.id,
            onChange: { (event: PlayerMoveEvent) in
                EventSystem.processedInputEvents.playerMoveEvent.post(event: event)
            },
            onError: nil
        )

        // Weapon change
        self.gameConnectionHandler.observeEvent(
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

    override func update(_ deltaTime: Double) {
        super.update(deltaTime)

        if !gameIsOver {
            sendGameState()
        }
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
        gameConnectionHandler.sendSystemData(data: systemData, gameID: room.gameID)
    }

    func readClientPlayerData(data: SystemData?) {
        guard let data = data else {
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

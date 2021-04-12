//
//  MultiplayerServer.swift
//  paintsplash
//
//  Created by Farrell Nah on 28/3/21.
//
import Foundation

class MultiplayerServer: SinglePlayerGameManager {
    var addedEntities = [EntityID: GameEntity]()
    var removedEntities = [EntityID: GameEntity]()
    var room: RoomInfo
    var connectionHandler: ConnectionHandler
    var gameConnectionHandler: GameConnectionHandler?

    private var collisionDetector: SKCollisionDetector!

    var lastProcessedInput = InputId(0)

    var historyManager = GameHistoryManager()

    init(roomInfo: RoomInfo, gameScene: GameScene) {
        self.room = roomInfo
        let connectionHandler = FirebaseConnectionHandler()
        self.connectionHandler = connectionHandler
        self.gameConnectionHandler = PaintSplashGameHandler(connectionHandler: connectionHandler)

        super.init(gameScene: gameScene)
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

    private func setupClientObservers(playerID: EntityID, gameId: String) {
        // Listen to user input from clients
        // Shooting input
        self.gameConnectionHandler?.observeEvent(
            gameId: gameId,
            playerId: playerID.id,
            onChange: { (event: PlayerShootEvent) in
                if let inputId = event.inputId,
                   inputId > self.lastProcessedInput {
                    print("\(inputId.id)")
                    EventSystem.processedInputEvents.playerShootEvent.post(event: event)
                    self.lastProcessedInput = inputId
                }
            },
            onError: nil
        )

        // Movement input
        self.gameConnectionHandler?.observeEvent(
            gameId: gameId,
            playerId: playerID.id,
            onChange: { (event: PlayerMoveEvent) in
                if let inputId = event.inputId,
                   inputId > self.lastProcessedInput {
                    print("\(inputId.id)")
                    EventSystem.processedInputEvents.playerMoveEvent.post(event: event)
                    self.lastProcessedInput = inputId
                }
            },
            onError: nil
        )

        // Weapon change
        self.gameConnectionHandler?.observeEvent(
            gameId: gameId,
            playerId: playerID.id,
            onChange: { (event: PlayerChangeWeaponEvent) in
                if let inputId = event.inputId, inputId > self.lastProcessedInput {
                    print("\(inputId.id)")
                    EventSystem.processedInputEvents.playerChangeWeaponEvent.post(event: event)
                    self.lastProcessedInput = inputId
                }
            },
            onError: nil
        )

        let path = DataPaths.joinPaths(
            DataPaths.games, gameId,
            DataPaths.game_players, playerID.id,
            "clientPlayer")

        self.connectionHandler.listen(to: path, callBack: readClientPlayerData)
    }

    func prepareGameState() -> SystemData {
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
        addedEntities.forEach({ _, entity in
            if let colorable = entity as? Colorable, !uiEntityIDs.contains(entity.id) {
                colorables[entity.id] = colorable
            }
        })

        let colorSystemData = ColorSystemData(from: colorables)

        let systemData = SystemData(
            date: Date(),
            lastProcessedInput: lastProcessedInput,
            entityData: entityData,
            renderSystemData: renderSystemData,
            animationSystemData: animationSystemData,
            colorSystemData: colorSystemData
        )
        return systemData
    }

    func prepareGameHistory(_ deltaTime: Double, _ data: SystemData) {
        let date = Date()
        let inputEvents = playerSystem.onMoveEvents + playerSystem.onShootEvents + playerSystem.onWeaponChangeEvents
        let updateLoopInfo = UpdateLoopInfo(
            inputEvents: inputEvents,
            updateDeltaTime: deltaTime,
            startGameState: data,
            entityIdCount: EntityID.nextID,
            entityIdMapping: EntityID.existingIDs)
        historyManager.stateHistory[date] = updateLoopInfo
    }

    override func update(_ deltaTime: Double) {
        currentLevel?.update()
        aiSystem.updateEntities(deltaTime)
        collisionSystem.updateEntities(deltaTime)
        movementSystem.updateEntities(deltaTime)
        entities.forEach({ $0.update(deltaTime) })

        let systemData = prepareGameState()
        prepareGameHistory(deltaTime, systemData)
        gameConnectionHandler?.sendSystemData(data: systemData, gameID: room.gameID)

        playerSystem.updateEntities(deltaTime)

        transformSystem.updateEntities(deltaTime)
        renderSystem.updateEntities(deltaTime)
        animationSystem.updateEntities(deltaTime)

        addedEntities = [:]
        removedEntities = [:]
    }

    override func addObject(_ object: GameEntity) {
        super.addObject(object)
        addedEntities[object.id] = object
    }

    override func removeObject(_ object: GameEntity) {
        super.removeObject(object)
        removedEntities[object.id] = object
    }

    func readClientPlayerData(data: SystemData?) {
        guard let clientData = data else {
            return
        }

        let clientDate = clientData.date
        let pastStates = historyManager.stateHistory
            .filter { $0.key > clientDate }
            .map { ($0.key, $0.value) }
            .sorted(by: { $0.0 < $1.0 })
            .map { $0.1 }
        guard !pastStates.isEmpty else {
            applyClientData(clientData)
            return
        }
        // reset to old state
        GameResolver.resolve(manager: self, with: pastStates[0].startGameState)
        EntityID.nextID = pastStates[0].entityIdCount
        EntityID.existingIDs = pastStates[0].entityIdMapping
        // apply the client data
        applyClientData(clientData)
        // run the update loops
        playerSystem.onMoveEvents = []
        playerSystem.onShootEvents = []
        playerSystem.onWeaponChangeEvents = []
        for state in pastStates {
            let deltaTime = state.updateDeltaTime
            for event in state.inputEvents {
                EventSystem.processedInputEvents.post(event: event)
            }
            aiSystem.updateEntities(deltaTime)
            movementSystem.updateEntities(deltaTime)
            playerSystem.updateEntities(deltaTime)
            transformSystem.updateEntities(deltaTime)
            addedEntities = [:]
            removedEntities = [:]
        }
        renderSystem.updateEntities(0)
    }

    func applyClientData(_ data: SystemData) {
        // apply client data
        let clientId = data.entityData.entities[0]
        if let client = entities.first(where: { $0.id.id == clientId.id }) as? Player,
           let renderComponent = data.renderSystemData?.renderables[clientId] {
            client.transformComponent = renderComponent.transformComponent
        }
    }
}

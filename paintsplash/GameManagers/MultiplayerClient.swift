//
//  MultiplayerClient.swift
//  paintsplash
//
//  Created by Cynthia Lee on 1/4/21.
// swiftlint:disable function_body_length

import Foundation

class MultiplayerClient: SinglePlayerGameManager {
    var room: RoomInfo

    var connectionHandler: ConnectionHandler = FirebaseConnectionHandler()
    var gameConnectionHandler: GameConnectionHandler =
        PaintSplashGameHandler(connectionHandler: FirebaseConnectionHandler())

    var historyManager = GameHistoryManager()
    var addedEntities = [EntityID: GameEntity]()
    var removedEntities = [EntityID: GameEntity]()
    
    var playerInfo: PlayerInfo

    init(gameScene: GameScene, playerInfo: PlayerInfo, roomInfo: RoomInfo) {
        self.playerInfo = playerInfo
        self.room = roomInfo

        super.init(gameScene: gameScene)
    }

    override func setupGame() {
        super.setupGame()
        setUpObservers()
        setUpInputListeners()
    }

    override func setUpPlayer() {
        player = Player(
            initialPosition: Vector2D.zero + Vector2D.left * 50,
            playerUUID: EntityID(id: playerInfo.playerUUID)
        )
        player.spawn()

        setUpGuestPlayer(player: room.host)

        // set up other players
        room.players?.forEach { _, player in
            if player.playerUUID != self.player.id.id {
                print("should not reach here since only 2 people")
                setUpGuestPlayer(player: player)
            }
        }
    }

    func setUpGuestPlayer(player: PlayerInfo) {
        // Initialize player
        let playerID = EntityID(id: player.playerUUID)

        let newPlayer = Player(initialPosition: Vector2D.zero + Vector2D.right * 50, playerUUID: playerID)
        newPlayer.spawn()
    }

    func setUpObservers() {
        let gameID = room.gameID

        gameConnectionHandler.observeEvent(
            gameId: gameID,
            playerId: playerInfo.playerUUID,
            onChange: {
                EventSystem.playerActionEvent.playerHealthUpdateEvent.post(event: $0)

            },
            onError: nil
        )

        gameConnectionHandler.observeEvent(
            gameId: gameID,
            playerId: playerInfo.playerUUID,
            onChange: { (event: PlayerChangedWeaponEvent) in
                EventSystem.playerActionEvent.playerChangedWeaponEvent.post(event: event)
            },
            onError: nil
        )

        gameConnectionHandler.observeEvent(
            gameId: gameID,
            playerId: playerInfo.playerUUID,
            onChange: {
                EventSystem.playerActionEvent.playerAmmoUpdateEvent.post(event: $0)
            },
            onError: nil
        )

        gameConnectionHandler.observeEvent(
            gameId: gameID,
            playerId: playerInfo.playerUUID,
            onChange: { [weak self] (event: PlayMusicEvent) in
                EventSystem.audioEvent.playMusicEvent.post(event: event)
                guard let playerId = self?.playerInfo.playerUUID else {
                    return
                }
                self?.gameConnectionHandler.acknowledgeEvent(
                    event,
                    gameId: gameID,
                    playerId: playerId,
                    onError: nil,
                    onSuccess: nil
                )
            },
            onError: nil
        )

        gameConnectionHandler.observeEvent(
            gameId: gameID,
            playerId: playerInfo.playerUUID,
            onChange: { [weak self] (event: PlaySoundEffectEvent) in
                EventSystem.audioEvent.playSoundEffectEvent.post(event: event)
                guard let playerId = self?.playerInfo.playerUUID else {
                    return
                }
                self?.gameConnectionHandler.acknowledgeEvent(
                    event,
                    gameId: gameID,
                    playerId: playerId,
                    onError: nil,
                    onSuccess: nil)
            },
            onError: nil
        )

        gameConnectionHandler.observeSystemData(gameID: gameID, callback: { [weak self] data in
            self?.updateSystemData(data: data)
        })
    }

    override func setUpSystems() {
        super.setUpSystems()
        audioManager = AudioManager(associatedDeviceId: EntityID(id: playerInfo.playerUUID))
    }

    func setUpInputListeners() {
        let gameId = self.room.gameID

        EventSystem.processedInputEvents.playerMoveEvent.subscribe { [weak self] in
            self?.sendPlayerMoveEvent($0, gameId: gameId)
        }

        EventSystem.processedInputEvents.playerShootEvent.subscribe { [weak self] in
            self?.sendPlayerShootEvent($0, gameId: gameId)
        }

        EventSystem.processedInputEvents.playerChangeWeaponEvent.subscribe { [weak self] in
            self?.sendPlayerWeaponChangeEvent($0, gameId: gameId)
        }
    }

    private func sendPlayerMoveEvent(_ event: PlayerMoveEvent, gameId: String) {
        self.gameConnectionHandler.sendEvent(
            gameId: gameId,
            playerId: event.playerId.id,
            action: event,
            onError: nil,
            onSuccess: nil
        )
    }

    private func sendPlayerShootEvent(_ event: PlayerShootEvent, gameId: String) {
        self.gameConnectionHandler.sendEvent(
            gameId: gameId,
            playerId: event.playerId.id,
            action: event,
            onError: nil,
            onSuccess: nil
        )
    }

    private func sendPlayerWeaponChangeEvent(_ event: PlayerChangeWeaponEvent, gameId: String) {
        self.gameConnectionHandler.sendEvent(
            gameId: gameId,
            playerId: event.playerId.id,
            action: event,
            onError: nil,
            onSuccess: nil
        )
    }

    func updateSystemData(data: SystemData?) {
        guard let data = data else {
            return
        }
        GameResolver.resolve(manager: self, with: data)
    }

    override func update(_ deltaTime: Double) {
        super.update(deltaTime)
        sendPlayerData()
        let gameState = prepareGameState()
        historyManager.addState(gameState, at: gameState.date)
        print(player.transformComponent.worldPosition)
        addedEntities = [:]
        removedEntities = [:]
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
            entityData: entityData,
            renderSystemData: renderSystemData,
            animationSystemData: animationSystemData,
            colorSystemData: colorSystemData
        )
        return systemData
    }
    
    override func addObject(_ object: GameEntity) {
        super.addObject(object)
        addedEntities[object.id] = object
    }

    override func removeObject(_ object: GameEntity) {
        super.removeObject(object)
        removedEntities[object.id] = object
    }
    
    func sendPlayerData() {
        let entityData = EntityData(from: [player])
        let renderableToSend: [EntityID: Renderable] = [player.id: player]
        let renderSystemData = RenderSystemData(from: renderableToSend)

        let systemData = SystemData(
            date: Date(),
            entityData: entityData,
            renderSystemData: renderSystemData,
            animationSystemData: nil,
            colorSystemData: nil
        )
        let path = DataPaths.joinPaths(
            DataPaths.games, room.gameID,
            DataPaths.game_players, player.id.id,
            "clientPlayer")
        connectionHandler.send(
            to: path,
            data: systemData,
            mode: .single,
            shouldRemoveOnDisconnect: true,
            onComplete: nil,
            onError: nil
        )
    }
}

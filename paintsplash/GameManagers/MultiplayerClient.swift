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

    var playerInfo: PlayerInfo
    var gameHistoryManager = GameHistoryManager()
    var isResolving = false
    var isUpdating = false
    
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
        event.inputId = InputId()
        gameHistoryManager.addInput(event)
        self.gameConnectionHandler.sendEvent(
            gameId: gameId,
            playerId: event.playerId.id,
            action: event,
            onError: nil,
            onSuccess: nil
        )
    }

    private func sendPlayerShootEvent(_ event: PlayerShootEvent, gameId: String) {
        event.inputId = InputId()
        gameHistoryManager.addInput(event)
        self.gameConnectionHandler.sendEvent(
            gameId: gameId,
            playerId: event.playerId.id,
            action: event,
            onError: nil,
            onSuccess: nil
        )
    }

    private func sendPlayerWeaponChangeEvent(_ event: PlayerChangeWeaponEvent, gameId: String) {
        event.inputId = InputId()
        gameHistoryManager.addInput(event)
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
        isResolving = true
        if isUpdating {
            fatalError("attempted to resolve while updating")
        }
        print("is resolving")
        let startPos = player.transformComponent.worldPosition
        // resets to oldstate via override
        GameResolver.resolve(manager: self, with: data)

        // process the prediction again from the previous authority state from server
        let gameState = GameState(data)
        RePrediction.resolve(gameState, self)
        isResolving = false
        let endPos = player.transformComponent.worldPosition
        print("          diff: \(startPos.x - endPos.x), \(startPos.y - endPos.y)")
        print("          expected Diff from: \(InputId.counter - data.lastProcessedInput.id)")
        print("done resolving")
    }

    override func update(_ deltaTime: Double) {
        let inputId = InputId(InputId.counter - 1)
        isUpdating = true
        if isResolving {
            fatalError("attempted to update while resolving")
        }
        print("is updating")
        super.update(deltaTime)
        print("done updating")
        isUpdating = false
        gameHistoryManager.addHistory(inputId, deltaTime)
    }
}

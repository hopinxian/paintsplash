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

    var serverNetworkHandler: MPClientNetworkHandler

    init(gameScene: GameScene, vc: GameViewController, playerInfo: PlayerInfo, roomInfo: RoomInfo) {
        self.playerInfo = playerInfo
        self.room = roomInfo
        self.serverNetworkHandler = FirebaseMPClientNetworkHandler(roomInfo: roomInfo)

        super.init(gameScene: gameScene, vc: vc)

        serverNetworkHandler.multiplayerClient = self
    }

    override func setupGame() {
        super.setupGame()
        setUpObservers()

        // Set up senders to send client player input to database
        serverNetworkHandler.setupPlayerInputSenders()
    }

    override func setUpPlayer() {
        player = Player(
            initialPosition: Vector2D.zero + Vector2D.left * 50,
            playerUUID: EntityID(id: playerInfo.playerUUID)
        )
        player.spawn()
    }

    override func setUpGeneralGameplayEntities() {
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
            onChange: { [weak self] (event: PlayerAmmoUpdateEvent) in
                EventSystem.playerActionEvent.playerAmmoUpdateEvent.post(event: event)
                self?.updatePlayerAmmo(event)
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

        gameConnectionHandler.observeEvent(
            gameId: gameID,
            playerId: playerInfo.playerUUID,
            onChange: { [weak self] (event: GameOverEvent) in
                EventSystem.gameStateEvents.gameOverEvent.post(event: event)
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
    }

    func updatePlayerAmmo(_ event: PlayerAmmoUpdateEvent) {
        if let weapon = player.multiWeaponComponent.availableWeapons.first(
            where: { event.weaponType == type(of: $0) }) {
            while weapon.canShoot() {
                _ = weapon.shoot(from: Vector2D.zero, in: Vector2D.zero)
            }
            weapon.load(event.ammo)
        }
    }

    override func setUpSystems() {
        super.setUpSystems()
        audioManager = AudioManager(associatedDeviceId: EntityID(id: playerInfo.playerUUID))
    }

    override func update(_ deltaTime: Double) {
        super.update(deltaTime)

        if !gameIsOver {
            sendPlayerData()
        }
    }

    func updateSystemData(data: SystemData?) {
        guard let data = data else {
            return
        }
        GameResolver.resolve(manager: self, with: data)
    }

    func sendPlayerData() {
        let entityData = EntityData(from: [player])
        let renderableToSend: [EntityID: Renderable] = [player.id: player]
        let renderSystemData = RenderSystemData(from: renderableToSend)

        let animatableToSend: [EntityID: Animatable] = [player.id: player]
        let animataionSystemData = AnimationSystemData(from: animatableToSend)
        let systemData = SystemData(
            entityData: entityData,
            renderSystemData: renderSystemData,
            animationSystemData: animataionSystemData,
            colorSystemData: nil
        )
        let path = DataPaths.joinPaths(
            DataPaths.games, room.gameID,
            DataPaths.game_players, player.id.id,
            "clientPlayer")
        connectionHandler.send(
            to: path,
            data: systemData,
            shouldRemoveOnDisconnect: true,
            onComplete: nil,
            onError: nil
        )
    }
}

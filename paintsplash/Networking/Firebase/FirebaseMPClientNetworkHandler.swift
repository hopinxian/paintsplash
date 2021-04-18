//
//  FirebaseMPClientNetworkHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 18/4/21.
//
class FirebaseMPClientNetworkHandler: MPClientNetworkHandler {
    weak var multiplayerClient: MultiplayerClient?

    var connectionHandler = FirebaseConnectionHandler()
    var gameConnectionHandler: GameConnectionHandler =
        PaintSplashGameHandler(connectionHandler: FirebaseConnectionHandler())

    let gameId: String
    let roomInfo: RoomInfo

    init(roomInfo: RoomInfo) {
        self.roomInfo = roomInfo
        self.gameId = roomInfo.gameID
    }

    func setupPlayerInputSenders() {
        setupPlayerMoveInputSender(gameId)
        setupPlayerShootInputSender(gameId)
        setupPlayerWeaponChangeSender(gameId)
    }

    func setupPlayerEventObservers(player: PlayerInfo) {
        let playerId = player.playerUUID
        let gameId = self.gameId

        observePlayerHealthEvent(playerId: playerId, gameId: gameId)
        observePlayerChangedWeaponEvent(playerId: playerId, gameId: gameId)
        observePlayerAmmoUpdateEvent(playerId: playerId, gameId: gameId)

        observeGameOver(playerId: playerId, gameId: gameId)
        observePlayMusicEvent(playerId: playerId, gameId: gameId)
        observePlaySoundEffectEvent(playerId: playerId, gameId: gameId)
    }

    func sendPlayerData() {
        sendPlayerDataToDatabase()
    }

    func observeSystemData() {
        gameConnectionHandler.observeSystemData(gameID: gameId, callback: { [weak self] data in
            self?.updateSystemData(data: data)
        })
    }

    private func updateSystemData(data: SystemData?) {
        guard let data = data,
              let client = multiplayerClient else {
            return
        }
        GameResolver.resolve(manager: client, with: data)
    }
}

// MARK: Client Input Senders
extension FirebaseMPClientNetworkHandler {
    private func setupPlayerMoveInputSender(_ gameId: String) {
        EventSystem.processedInputEvents.playerMoveEvent.subscribe { [weak self] event in
            self?.gameConnectionHandler.sendEvent(
                gameId: gameId,
                playerId: event.playerId.id,
                event: event,
                onError: nil,
                onSuccess: nil
            )
        }
    }

    private func setupPlayerShootInputSender(_ gameId: String) {
        EventSystem.processedInputEvents.playerShootEvent.subscribe { [weak self] event in
            self?.gameConnectionHandler.sendEvent(
                gameId: gameId,
                playerId: event.playerId.id,
                event: event,
                onError: nil,
                onSuccess: nil
            )
        }
    }

    private func setupPlayerWeaponChangeSender(_ gameId: String) {
        EventSystem.processedInputEvents.playerChangeWeaponEvent.subscribe { [weak self] event in
            self?.gameConnectionHandler.sendEvent(
                gameId: gameId,
                playerId: event.playerId.id,
                event: event,
                onError: nil,
                onSuccess: nil
            )
        }
    }
}

// MARK: Client Event Observers
extension FirebaseMPClientNetworkHandler {
    private func observePlayerHealthEvent(playerId: String, gameId: String) {
        gameConnectionHandler.observeEvent(
            gameId: gameId,
            playerId: playerId,
            onChange: { (event: PlayerHealthUpdateEvent) in
                EventSystem.playerActionEvent.playerHealthUpdateEvent.post(event: event)
            },
            onError: nil
        )
    }

    private func observePlayerChangedWeaponEvent(playerId: String, gameId: String) {
        gameConnectionHandler.observeEvent(
            gameId: gameId,
            playerId: playerId,
            onChange: { (event: PlayerChangedWeaponEvent) in
                EventSystem.playerActionEvent.playerChangedWeaponEvent.post(event: event)
            },
            onError: nil
        )
    }

    private func observePlayerAmmoUpdateEvent(playerId: String, gameId: String) {
        gameConnectionHandler.observeEvent(
            gameId: gameId,
            playerId: playerId,
            onChange: { [weak self] (event: PlayerAmmoUpdateEvent) in
                EventSystem.playerActionEvent.playerAmmoUpdateEvent.post(event: event)
                self?.updatePlayerAmmo(event)
            },
            onError: nil
        )
    }

    private func updatePlayerAmmo(_ event: PlayerAmmoUpdateEvent) {
        guard let player = multiplayerClient?.player else {
            return
        }
        if let weapon = player.multiWeaponComponent.availableWeapons.first(
            where: { event.weaponType == type(of: $0) }) {
            while weapon.canShoot() {
                _ = weapon.shoot(from: Vector2D.zero, in: Vector2D.zero)
            }
            weapon.load(event.ammo)
        }
    }

    private func observeGameOver(playerId: String, gameId: String) {
        gameConnectionHandler.observeEvent(
            gameId: gameId,
            playerId: playerId,
            onChange: { [weak self] (event: GameOverEvent) in
                EventSystem.gameStateEvents.gameOverEvent.post(event: event)
                self?.gameConnectionHandler.acknowledgeEvent(
                    event,
                    gameId: gameId,
                    playerId: playerId,
                    onError: nil,
                    onSuccess: nil
                )
            },
            onError: nil
        )
    }

    private func observePlayMusicEvent(playerId: String, gameId: String) {
        gameConnectionHandler.observeEvent(
            gameId: gameId,
            playerId: playerId,
            onChange: { [weak self] (event: PlayMusicEvent) in
                EventSystem.audioEvent.playMusicEvent.post(event: event)
                self?.gameConnectionHandler.acknowledgeEvent(
                    event,
                    gameId: gameId,
                    playerId: playerId,
                    onError: nil,
                    onSuccess: nil
                )
            },
            onError: nil
        )
    }

    private func observePlaySoundEffectEvent(playerId: String, gameId: String) {
        gameConnectionHandler.observeEvent(
            gameId: gameId,
            playerId: playerId,
            onChange: { [weak self] (event: PlaySoundEffectEvent) in
                EventSystem.audioEvent.playSoundEffectEvent.post(event: event)
                self?.gameConnectionHandler.acknowledgeEvent(
                    event,
                    gameId: gameId,
                    playerId: playerId,
                    onError: nil,
                    onSuccess: nil)
            },
            onError: nil
        )
    }
}

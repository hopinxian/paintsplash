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

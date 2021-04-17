//
//  FirebaseGameHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 30/3/21.
//

class PaintSplashGameHandler: GameConnectionHandler {
    let connectionHandler: ConnectionHandler

    init(connectionHandler: ConnectionHandler) {
        self.connectionHandler = connectionHandler
    }

    private func getEventPath(_ event: Event.Type) -> String? {
        switch event {
        case is PlayerMoveEvent.Type:
            return DataPaths.player_moveInput
        case is PlayerShootEvent.Type:
            return DataPaths.player_shootInput
        case is PlayerChangeWeaponEvent.Type:
            return DataPaths.player_weaponChoice
        case is PlayerAmmoUpdateEvent.Type:
            return DataPaths.player_ammoUpdate
        case is PlayerHealthUpdateEvent.Type:
            return DataPaths.player_healthUpdate
        case is PlaySoundEffectEvent.Type:
            return DataPaths.player_soundEffect
        case is PlayMusicEvent.Type:
            return DataPaths.player_music
        case is PlayerChangedWeaponEvent.Type:
            return DataPaths.player_changedWeapon
        case is GameOverEvent.Type:
            return DataPaths.game_over
        default:
            return nil
        }
    }

    func sendEvent<T>(
        gameId: String,
        playerId: String, action: T,
        onError: ((Error?) -> Void)?,
        onSuccess: (() -> Void)?
    ) where T: Decodable, T: Encodable, T: Event {

        guard let path = getEventPath(T.self) else {
            onError?(nil)
            return
        }

        let playerPath = DataPaths.joinPaths(
            DataPaths.games, gameId,
            DataPaths.game_players, playerId,
            path
        )

        connectionHandler.send(
            to: playerPath, data: action,
            shouldRemoveOnDisconnect: false,
            onComplete: onSuccess, onError: onError
        )
    }

    func observeEvent<T: Codable>(
        gameId: String,
        playerId: String,
        onChange: ((T) -> Void)?,
        onError: ((Error?) -> Void)?
    ) where T: Event {
        guard let path = getEventPath(T.self) else {
            onError?(nil)
            return
        }

        let playerPath = DataPaths.joinPaths(
            DataPaths.games, gameId,
            DataPaths.game_players, playerId,
            path
        )

        connectionHandler.listen(
            to: playerPath,
            callBack: { (event: T?) in
                guard let event = event else {
                    return
                }
                onChange?(event)
            }
        )
    }

    func acknowledgeEvent<T: Codable>(
        _ event: T,
        gameId: String,
        playerId: String,
        onError: ((Error?) -> Void)?,
        onSuccess: (() -> Void)?
    ) where T: Event {
        guard let path = getEventPath(T.self) else {
            onError?(nil)
            return
        }

        let playerPath = DataPaths.joinPaths(
            DataPaths.games, gameId,
            DataPaths.game_players, playerId,
            path
        )

        connectionHandler.removeData(at: playerPath) { error in
            guard let err = error else {
                onSuccess?()
                return
            }

            onError?(err)
        }
    }

    func sendSystemData(data: SystemData, gameID: String) {
        let systemPath = DataPaths.joinPaths(DataPaths.games, gameID, DataPaths.systems)
        connectionHandler.send(to: systemPath, data: data, shouldRemoveOnDisconnect: false,
                               onComplete: nil, onError: nil)
    }

    func observeSystemData(gameID: String, callback: @escaping (SystemData?) -> Void) {
        let systemPath = DataPaths.joinPaths(
            DataPaths.games,
            gameID,
            DataPaths.systems
        )
        connectionHandler.listen(to: systemPath, callBack: callback)
    }
}

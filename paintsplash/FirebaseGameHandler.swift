//
//  FirebaseGameHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 30/3/21.
//

class FirebaseGameHandler: GameConnectionHandler {
    let connectionHandler = FirebaseConnectionHandler()

    private func getEventPath(_ event: Event.Type) -> String? {
        switch event {
        case is PlayerMoveEvent.Type:
            return FirebasePaths.player_moveInput
        case is PlayerShootEvent.Type:
            return FirebasePaths.player_shootInput
        case is PlayerChangeWeaponEvent.Type:
            return FirebasePaths.player_weaponChoice
        case is PlayerAmmoUpdateEvent.Type:
            return FirebasePaths.player_ammoUpdate
        case is PlayerHealthUpdateEvent.Type:
            return FirebasePaths.player_healthUpdate
        default:
            return nil
        }
    }

    func sendPlayerEvent<T: Codable>(gameId: String, playerId: String, action: T) where T: Event {
        guard let path = getEventPath(T.self) else {
            return
        }

        let playerPath = FirebasePaths.joinPaths(FirebasePaths.games, gameId,
                                                 FirebasePaths.game_players, playerId,
                                                 path)
        connectionHandler.send(to: playerPath, data: action,
                               mode: .single, shouldRemoveOnDisconnect: true,
                               onComplete: nil, onError: nil)
    }

    func observePlayerEvent<T: Codable>(gameId: String, playerId: String, onChange: ((T) -> Void)?) where T: Event {
        guard let path = getEventPath(T.self) else {
            return
        }

        let playerPath = FirebasePaths.joinPaths(FirebasePaths.games, gameId,
                                                 FirebasePaths.game_players, playerId,
                                                 path)
        connectionHandler.listen(to: playerPath, callBack: { (event: T?) in
            guard let event = event else {
                return
            }
            onChange?(event)
        })
    }
}

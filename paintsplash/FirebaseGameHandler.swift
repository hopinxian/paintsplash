//
//  FirebaseGameHandler.swift
//  paintsplash
//
//  Created by Cynthia Lee on 30/3/21.
//

class FirebaseGameHandler: GameConnectionHandler {
    let connectionHandler = FirebaseConnectionHandler()

    func addEntity(gameId: String, entity: GameEntity) {
    }

//    func sendPlayerState(gameId: String, playerId: String, playerState: PlayerStateInfo) {
//        let playerPath = FirebasePaths.joinPaths(FirebasePaths.games, gameId, FirebasePaths.game_players, playerId)
//        connectionHandler.send(to: playerPath, data: playerState,
//                               mode: .single,
//                               shouldRemoveOnDisconnect: true, onComplete: { print("updated player state") },
//                               onError: nil)
//    }
//
//    func observePlayerState(gameId: String, playerId: String, onChange: ((PlayerStateInfo) -> Void)?) {
//        let playerPath = FirebasePaths.joinPaths(FirebasePaths.games, gameId, FirebasePaths.game_players, playerId)
//        connectionHandler.listen(to: playerPath) { (playerStateInfo: PlayerStateInfo?) in
//            guard let playerStateInfo = playerStateInfo else {
//                return
//            }
//            onChange?(playerStateInfo)
//        }
//    }

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
//
//    func sendPlayerMoveInput(gameId: String, playerId: String, playerMoveEvent: PlayerMoveEvent) {
//        let playerPath = FirebasePaths.joinPaths(FirebasePaths.games, gameId,
//                                                 FirebasePaths.game_players, playerId,
//                                                 FirebasePaths.player_moveInput)
//        connectionHandler.send(to: playerPath, data: playerMoveEvent,
//                               mode: .single, shouldRemoveOnDisconnect: true,
//                               onComplete: nil, onError: nil)
//    }
//
//    func observePlayerMoveInput(gameId: String, playerId: String, onChange: ((PlayerMoveEvent) -> Void)?) {
//        let playerPath = FirebasePaths.joinPaths(FirebasePaths.games, gameId,
//                                                 FirebasePaths.game_players, playerId,
//                                                 FirebasePaths.player_moveInput)
//        connectionHandler.listen(to: playerPath, callBack: { (playerMoveEvent: PlayerMoveEvent?) in
//            guard let playerMoveEvent = playerMoveEvent else {
//                return
//            }
//            onChange?(playerMoveEvent)
//        })
//    }
//
//    func sendPlayerShootInput(gameId: String, playerId: String, playerShootEvent: PlayerShootEvent) {
//        let playerPath = FirebasePaths.joinPaths(FirebasePaths.games, gameId,
//                                                 FirebasePaths.game_players, playerId,
//                                                 FirebasePaths.player_shootInput)
//        connectionHandler.send(to: playerPath, data: playerShootEvent,
//                               mode: .single, shouldRemoveOnDisconnect: true,
//                               onComplete: nil, onError: nil)
//    }
//
//    func observePlayerShootInput(gameId: String, playerId: String, onChange: ((PlayerShootEvent) -> Void)?) {
//        let playerPath = FirebasePaths.joinPaths(FirebasePaths.games, gameId,
//                                                 FirebasePaths.game_players, playerId,
//                                                 FirebasePaths.player_shootInput)
//        connectionHandler.listen(to: playerPath, callBack: { (playerShootEvent: PlayerShootEvent?) in
//            guard let playerShootEvent = playerShootEvent else {
//                return
//            }
//            onChange?(playerShootEvent)
//        })
//    }
//
//    func sendPlayerChangeWeapon(gameId: String, playerId: String, changeWeaponEvent: PlayerChangeWeaponEvent) {
//        let playerPath = FirebasePaths.joinPaths(FirebasePaths.games, gameId,
//                                                 FirebasePaths.game_players, playerId,
//                                                 FirebasePaths.player_weaponChoice)
//        connectionHandler.send(to: playerPath, data: changeWeaponEvent,
//                               mode: .single, shouldRemoveOnDisconnect: true,
//                               onComplete: nil, onError: nil)
//    }
//
//    func observePlayerChangeWeapon(gameId: String, playerId: String, onChange: ((PlayerChangeWeaponEvent) -> Void)?) {
//        let playerPath = FirebasePaths.joinPaths(FirebasePaths.games, gameId,
//                                                 FirebasePaths.game_players, playerId,
//                                                 FirebasePaths.player_weaponChoice)
//        connectionHandler.listen(to: playerPath, callBack: { (playerChangeWeaponEvent: PlayerChangeWeaponEvent?) in
//            guard let playerChangeWeaponEvent = playerChangeWeaponEvent else {
//                return
//            }
//            onChange?(playerChangeWeaponEvent)
//        })
//    }
}

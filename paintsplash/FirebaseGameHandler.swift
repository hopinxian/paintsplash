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

    func sendPlayerState(gameId: String, playerId: String, playerState: PlayerStateInfo) {
        let playerPath = FirebasePaths.joinPaths(FirebasePaths.games, gameId, FirebasePaths.game_players, playerId)
        connectionHandler.send(to: playerPath, data: playerState,
                               mode: .single,
                               shouldRemoveOnDisconnect: true, onComplete: { print("updated player state") },
                               onError: nil)
    }

    func observePlayerState(gameId: String, playerId: String, onChange: ((PlayerStateInfo) -> Void)?) {
        let playerPath = FirebasePaths.joinPaths(FirebasePaths.games, gameId, FirebasePaths.game_players, playerId)
        connectionHandler.listen(to: playerPath) { (playerStateInfo: PlayerStateInfo?) in
            guard let playerStateInfo = playerStateInfo else {
                return
            }
            onChange?(playerStateInfo)
        }
    }

    func sendPlayerMoveInput(gameId: String, playerId: String, playerMoveEvent: PlayerMoveEvent) {
        let playerPath = FirebasePaths.joinPaths(FirebasePaths.games, gameId,
                                                 FirebasePaths.game_players, playerId,
                                                 FirebasePaths.player_moveInput)
        connectionHandler.send(to: playerPath, data: playerMoveEvent,
                               mode: .single, shouldRemoveOnDisconnect: true,
                               onComplete: nil, onError: nil)
    }

    func observePlayerMoveInput(gameId: String, playerId: String, onChange: ((PlayerMoveEvent) -> Void)?) {
        let playerPath = FirebasePaths.joinPaths(FirebasePaths.games, gameId,
                                                 FirebasePaths.game_players, playerId,
                                                 FirebasePaths.player_moveInput)
        connectionHandler.listen(to: playerPath, callBack: { (playerMoveEvent: PlayerMoveEvent?) in
            guard let playerMoveEvent = playerMoveEvent else {
                return
            }
            onChange?(playerMoveEvent)
        })
    }

    func sendPlayerShootInput(gameId: String, playerId: String, playerShootEvent: PlayerShootEvent) {
        let playerPath = FirebasePaths.joinPaths(FirebasePaths.games, gameId,
                                                 FirebasePaths.game_players, playerId,
                                                 FirebasePaths.player_shootInput)
        connectionHandler.send(to: playerPath, data: playerShootEvent,
                               mode: .single, shouldRemoveOnDisconnect: true,
                               onComplete: nil, onError: nil)
    }

    func observePlayerShootInput(gameId: String, playerId: String, onChange: ((PlayerShootEvent) -> Void)?) {
        let playerPath = FirebasePaths.joinPaths(FirebasePaths.games, gameId,
                                                 FirebasePaths.game_players, playerId,
                                                 FirebasePaths.player_shootInput)
        connectionHandler.listen(to: playerPath, callBack: { (playerShootEvent: PlayerShootEvent?) in
            guard let playerShootEvent = playerShootEvent else {
                return
            }
            onChange?(playerShootEvent)
        })
    }


}

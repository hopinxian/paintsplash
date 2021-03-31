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
}

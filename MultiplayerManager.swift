//
//  MultiplayerManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 28/3/21.
//

class MultiplayerServer: GameManager {
    var entities = Set<GameEntity>()
    var lobby: MultiplayerLobby
    var connectionHandler: ConnectionHandler

    init(connectionHandler: ConnectionHandler, lobby: MultiplayerLobby) {
        self.connectionHandler = connectionHandler
        self.lobby = lobby
    }

    func sendGameState() {

    }

    func receiveInput() {

    }

    func update() {

    }

    func addObject(_ object: GameEntity) {

    }

    func removeObject(_ object: GameEntity) {
        
    }
}

class MultiplayerClient: GameManager {
    var entities = Set<GameEntity>()
    var lobby: MultiplayerLobby?
    var connectionHandler: ConnectionHandler
    var multiplayerMatchmaker: MultiplayerMatchmaker

    init(connectionHandler: ConnectionHandler, matchMaker: MultiplayerMatchmaker) {
        self.multiplayerMatchmaker = matchMaker
        self.connectionHandler = connectionHandler
    }

    func joinLobby(code: String) throws {
        guard !inLobby() else {
            throw MultiplayerError.alreadyInLobby
        }

        let joinedLobby = try multiplayerMatchmaker.joinLobby(code)
        self.lobby = joinedLobby

        let server = MultiplayerServer(connectionHandler: connectionHandler, lobby: joinedLobby)
    }

    func inLobby() -> Bool {
        lobby != nil
    }

    func updateGameState() {

    }

    func sendInput(event: TouchInputEvent) {

    }

    func update() {

    }

    func addObject(_ object: GameEntity) {

    }

    func removeObject(_ object: GameEntity) {
        
    }
}

enum MultiplayerError: Error {
    case alreadyInLobby
    case cannotJoinLobby
}

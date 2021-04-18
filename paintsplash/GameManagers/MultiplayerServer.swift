//
//  MultiplayerServer.swift
//  paintsplash
//
//  Created by Farrell Nah on 28/3/21.
//
import Foundation

class MultiplayerServer: SinglePlayerGameManager {
    var room: RoomInfo
    var serverNetworkHandler: MPServerNetworkHandler

    private var collisionDetector: SKCollisionDetector!

    init(roomInfo: RoomInfo, gameScene: GameScene, vc: GameViewController) {
        self.room = roomInfo
        self.serverNetworkHandler = FirebaseMPServerNetworkHandler(roomInfo: roomInfo)
        super.init(gameScene: gameScene, vc: vc)

        serverNetworkHandler.multiplayerServer = self
    }

    override func setUpPlayer() {
        let hostId = EntityID(id: room.host.playerUUID)

        player = Player(initialPosition: Vector2D.zero + Vector2D.right * 50, playerUUID: hostId)
        player.spawn()

        // Set up other players
        room.players?.forEach { _, player in
            setUpGuestPlayer(player: player)
        }
    }

    func setUpGuestPlayer(player: PlayerInfo) {
        // Initialize each guest player
        let playerID = EntityID(id: player.playerUUID)
        let newPlayer = Player(initialPosition: Vector2D.zero + Vector2D.left * 50, playerUUID: playerID)
        newPlayer.spawn()

        // Allow server to send player-related events to the database for clients to observe
        // and for server to listen to player-related events sent from client to update
        // game state
        let gameId = self.room.gameID
        serverNetworkHandler.setupClientPlayer(player: player)

        serverNetworkHandler.setUpGameEventSenders()

        setupGameOverEventSender(playerInfo: player, gameId)
    }

    private func setupGameOverEventSender(playerInfo: PlayerInfo, _ gameId: String) {
        EventSystem.gameStateEvents.gameOverEvent.subscribe { [weak self] event in
            guard (self?.room.players) != nil else {
                return
            }
            event.score = self?.currentLevel?.currentScore
            self?.serverNetworkHandler.sendGameOverEvent(event: event, playerInfo: playerInfo)
        }
    }

    override func update(_ deltaTime: Double) {
        super.update(deltaTime)

        if !gameIsOver {
            sendGameState()
        }
    }

    func sendGameState() {
        serverNetworkHandler.sendGameState(uiEntities: uiEntities, entities: entities,
                                           renderSystem: renderSystem, animationSystem: animationSystem)
    }
}

//
//  MultiplayerServer.swift
//  paintsplash
//
//  Created by Farrell Nah on 28/3/21.
//
import Foundation

class MultiplayerServer: SinglePlayerGameManager {
    var room: RoomInfo
    var connectionHandler = FirebaseConnectionHandler()
    var gameConnectionHandler: GameConnectionHandler =
        PaintSplashGameHandler(connectionHandler: FirebaseConnectionHandler())

    let serverNetworkHandler: MPServerNetworkHandler

    private var collisionDetector: SKCollisionDetector!

    init(roomInfo: RoomInfo, gameScene: GameScene, vc: GameViewController) {
        self.room = roomInfo
        self.serverNetworkHandler = FirebaseMPServerNetworkHandler(roomInfo: roomInfo)
        super.init(gameScene: gameScene, vc: vc)
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

        setupGameOverEventSender(playerID: playerID, gameId)
        setupClientObservers(playerID: playerID, gameId: gameId)
    }

    private func setupGameOverEventSender(playerID: EntityID, _ gameId: String) {
        EventSystem.gameStateEvents.gameOverEvent.subscribe { [weak self] event in
            guard (self?.room.players) != nil else {
                return

            }
            event.score = self?.currentLevel?.score.score
            self?.gameConnectionHandler.sendEvent(
                gameId: gameId,
                playerId: playerID.id,
                event: event,
                onError: nil,
                onSuccess: nil
            )
        }
    }

    private func setupClientObservers(playerID: EntityID, gameId: String) {
        // player state observing
        let path = DataPaths.joinPaths(
            DataPaths.games, gameId,
            DataPaths.game_players, playerID.id,
            "clientPlayer")
        self.connectionHandler.listen(to: path, callBack: { [weak self] in
            self?.readClientPlayerData(data: $0)
        })
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

    func readClientPlayerData(data: SystemData?) {
        guard let data = data else {
            return
        }
        let clientId = data.entityData.entities[0]
        if let client = entities.first(where: { $0.id.id == clientId.id }) as? Player,
            let transformComponent = data.renderSystemData?.renderables[clientId]?.transformComponent,
            let animationComponent = data.animationSystemData?.animatables[clientId]?.animationComponent,
            let renderComponent = data.renderSystemData?.renderables[clientId]?.renderComponent {
            let boundedComponent = BoundedTransformComponent(
                position: transformComponent.worldPosition,
                rotation: transformComponent.rotation,
                size: transformComponent.size,
                bounds: Constants.PLAYER_MOVEMENT_BOUNDS)
            client.transformComponent = boundedComponent
            client.renderComponent = renderComponent
            client.animationComponent = animationComponent
        }
    }
}

//
//  MultiplayerClient.swift
//  paintsplash
//
//  Created by Cynthia Lee on 1/4/21.

import Foundation

class MultiplayerClient: SinglePlayerGameManager {
    var room: RoomInfo
    var connectionHandler: ConnectionHandler = FirebaseConnectionHandler()
    var gameConnectionHandler: GameConnectionHandler =
        PaintSplashGameHandler(connectionHandler: FirebaseConnectionHandler())

    var playerInfo: PlayerInfo

    var serverNetworkHandler: MPClientNetworkHandler

    init(gameScene: GameScene, vc: GameViewController, playerInfo: PlayerInfo, roomInfo: RoomInfo) {
        self.playerInfo = playerInfo
        self.room = roomInfo
        self.serverNetworkHandler = FirebaseMPClientNetworkHandler(roomInfo: roomInfo)

        super.init(gameScene: gameScene, vc: vc)

        serverNetworkHandler.multiplayerClient = self
    }

    override func setupGame() {
        super.setupGame()
        setUpObservers()

        // Set up senders to send client player input to database
        serverNetworkHandler.setupPlayerInputSenders()

        // Set up listeners to observe changes from server side
        serverNetworkHandler.setupPlayerEventObservers(player: playerInfo)
    }

    override func setUpPlayer() {
        player = Player(
            initialPosition: Vector2D.zero + Vector2D.left * 50,
            playerUUID: EntityID(id: playerInfo.playerUUID)
        )
        player.spawn()
    }

    override func setUpGeneralGameplayEntities() {
    }

    func setUpObservers() {
        let gameID = room.gameID

        gameConnectionHandler.observeSystemData(gameID: gameID, callback: { [weak self] data in
            self?.updateSystemData(data: data)
        })
    }

    override func setUpSystems() {
        super.setUpSystems()
        audioManager = AudioManager(associatedDeviceId: EntityID(id: playerInfo.playerUUID))
    }

    override func update(_ deltaTime: Double) {
        super.update(deltaTime)

        if !gameIsOver {
            sendPlayerData()
        }
    }

    func updateSystemData(data: SystemData?) {
        guard let data = data else {
            return
        }
        GameResolver.resolve(manager: self, with: data)
    }

    func sendPlayerData() {
        let entityData = EntityData(from: [player])
        let renderableToSend: [EntityID: Renderable] = [player.id: player]
        let renderSystemData = RenderSystemData(from: renderableToSend)

        let animatableToSend: [EntityID: Animatable] = [player.id: player]
        let animataionSystemData = AnimationSystemData(from: animatableToSend)
        let systemData = SystemData(
            entityData: entityData,
            renderSystemData: renderSystemData,
            animationSystemData: animataionSystemData,
            colorSystemData: nil
        )
        let path = DataPaths.joinPaths(
            DataPaths.games, room.gameID,
            DataPaths.game_players, player.id.id,
            DataPaths.game_client_player)
        connectionHandler.send(
            to: path,
            data: systemData,
            shouldRemoveOnDisconnect: true,
            onComplete: nil,
            onError: nil
        )
    }
}

//
//  MultiplayerClient.swift
//  paintsplash
//
//  Created by Cynthia Lee on 1/4/21.

import Foundation

class MultiplayerClient: SinglePlayerGameManager {
    var room: RoomInfo
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

        // Set up senders to send client player input to database
        serverNetworkHandler.setupPlayerInputSenders()

        // Set up listeners to observe changes from server side
        serverNetworkHandler.setupPlayerEventObservers(player: playerInfo)

        serverNetworkHandler.observeSystemData()
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

    override func setUpSystems() {
        super.setUpSystems()
        audioManager = AudioManager(associatedDeviceId: EntityID(id: playerInfo.playerUUID))
    }

    override func update(_ deltaTime: Double) {
        super.update(deltaTime)

        if !gameIsOver {
            serverNetworkHandler.sendPlayerData()
        }
    }
}

//
//  MultiplayerServer.swift
//  paintsplash
//
//  Created by Farrell Nah on 28/3/21.
//

import Foundation

class MultiplayerServer: SinglePlayerGameManager {
    var room: RoomInfo
    var lobbyHandler: LobbyHandler
    var gameConnectionHandler: GameConnectionHandler?
    var gameId: String?

    // var otherPlayer: Player!
    var guestPlayers = Set<Player>()

    private var collisionDetector: SKCollisionDetector!

    init(lobbyHandler: LobbyHandler, roomInfo: RoomInfo, gameScene: GameScene) {
        self.lobbyHandler = lobbyHandler
        self.room = roomInfo
        self.gameId = roomInfo.gameId
        super.init(gameScene: gameScene)
    }

    override func setupGame() {
        self.gameConnectionHandler = FirebaseGameHandler()
        setUpSystems()
        setUpEntities()
        setUpPlayer()
        setUpUI()
    }

    override func setUpPlayer() {
        guard let hostId = UUID(uuidString: room.host.playerUUID) else {
            fatalError("Error fetching IDs of players")
        }

        player = Player(initialPosition: Vector2D.zero + Vector2D.right * 50, playerUUID: hostId)
        player.spawn()

        EventSystem.playerActionEvent.playerHealthUpdateEvent.subscribe(listener: { event in
            guard event.playerId == hostId else {
                return
            }
            self.gameConnectionHandler?.sendPlayerState(gameId: self.gameId ?? "",
                                                        playerId: hostId.uuidString,
                                                        playerState: PlayerStateInfo(playerId: hostId,
                                                                                     health: event.newHealth))
        })

        // set up other players
        room.players?.forEach { _, player in
            setUpGuestPlayer(player: player)
        }
    }

    func setUpGuestPlayer(player: PlayerInfo) {
        // Initialize player
        guard let playerID = UUID(uuidString: player.playerUUID),
            let gameId = self.gameId else {
            return
        }
        let newPlayer = Player(initialPosition: Vector2D.zero + Vector2D.left * 50, playerUUID: playerID)
        newPlayer.spawn()

        // Send player state updates to DB
        EventSystem.playerActionEvent.playerHealthUpdateEvent.subscribe(listener: { event in
            guard event.playerId == playerID else {
                return
            }
            self.gameConnectionHandler?.sendPlayerState(gameId: gameId,
                                                        playerId: playerID.uuidString,
                                                        playerState: PlayerStateInfo(playerId: playerID,
                                                                                     health: event.newHealth))
        })

        // Update player ammo
        EventSystem.playerActionEvent.playerAmmoUpdateEvent.subscribe(listener: { event in
            guard event.playerId == playerID else {
                return
            }
        })

        // Listen to user input from clients

        // Shooting input
        self.gameConnectionHandler?.observePlayerEvent(
            gameId: gameId,
            playerId: playerID.uuidString,
            onChange: { EventSystem.processedInputEvents.playerShootEvent.post(event: $0) }
        )

        // Movement input

        self.gameConnectionHandler?.observePlayerEvent(
            gameId: gameId,
            playerId: playerID.uuidString,
            onChange: { EventSystem.processedInputEvents.playerMoveEvent.post(event: $0) }
        )

        // Weapon change

        self.gameConnectionHandler?.observePlayerEvent(
            gameId: gameId,
            playerId: playerID.uuidString,
            onChange: { EventSystem.processedInputEvents.playerChangeWeaponEvent.post(event: $0) }
        )
    }

    override func setUpEntities() {
        let background = Background()
        background.spawn()

        let canvasSpawner = CanvasSpawner(
            initialPosition: Constants.CANVAS_SPAWNER_POSITION,
            canvasVelocity: Vector2D(0.4, 0),
            spawnInterval: 10
        )
        canvasSpawner.spawn()

        let canvasManager = CanvasRequestManager()
        canvasManager.spawn()

        let canvasEndMarker = CanvasEndMarker(size: Constants.CANVAS_END_MARKER_SIZE,
                                              position: Constants.CANVAS_END_MARKER_POSITION)
        canvasEndMarker.spawn()

        currentLevel = Level.getDefaultLevel(gameManager: self, canvasManager: canvasManager)
        currentLevel?.run()
    }

    override func setUpUI() {
        guard let paintGun = player.multiWeaponComponent.availableWeapons.compactMap({ $0 as? PaintGun }).first else {
            fatalError("PaintGun not setup properly")
        }

        let paintGunUI = PaintGunAmmoDisplay(weaponData: paintGun, associatedEntity: player.id)
        paintGunUI.spawn()
        paintGunUI.ammoDisplayView.animationComponent.animate(animation: WeaponAnimations.selectWeapon, interupt: true)

        guard let paintBucket = player.multiWeaponComponent.availableWeapons.compactMap({ $0 as? Bucket }).first else {
            fatalError("PaintBucket not setup properly")
        }

        let paintBucketUI = PaintBucketAmmoDisplay(weaponData: paintBucket, associatedEntity: player.id)
        paintBucketUI.spawn()
        paintBucketUI.ammoDisplayView.animationComponent.animate(
            animation: WeaponAnimations.unselectWeapon,
            interupt: true
        )

        let joystick = MovementJoystick(associatedEntityID: player.id, position: Constants.JOYSTICK_POSITION)
        joystick.spawn()

        let attackButton = AttackJoystick(associatedEntityID: player.id, position: Constants.ATTACK_BUTTON_POSITION)
        attackButton.spawn()

        let playerHealthUI = PlayerHealthDisplay(startingHealth: player.healthComponent.currentHealth,
                                                 associatedEntityId: player.id)
        playerHealthUI.spawn()

        let bottombar = UIBar(
            position: Constants.BOTTOM_BAR_POSITION,
            size: Constants.BOTTOM_BAR_SIZE,
            spritename: Constants.BOTTOM_BAR_SPRITE
        )
        bottombar.spawn()

        let topBar = UIBar(
            position: Constants.TOP_BAR_POSITION,
            size: Constants.TOP_BAR_SIZE,
            spritename: Constants.TOP_BAR_SPRITE
        )
        topBar.spawn()
    }

    func sendGameState() {

    }

    func receiveInput() {

    }

    private func onAddEntity(event: AddEntityEvent) {
        addObject(event.entity)
    }
//
//    func addObject(_ object: GameEntity) {
//        entities.insert(object)
//        renderSystem.addEntity(object)
//        aiSystem.addEntity(object)
//        collisionSystem.addEntity(object)
//        movementSystem.addEntity(object)
//        animationSystem.addEntity(object)
//
//        // TODO: adding child
//
//    }

    private func onRemoveEntity(event: RemoveEntityEvent) {
        removeObject(event.entity)
    }

//    func removeObject(_ object: GameEntity) {
//        entities.remove(object)
//        renderSystem.removeEntity(object)
//        aiSystem.removeEntity(object)
//        collisionSystem.removeEntity(object)
//        movementSystem.removeEntity(object)
//        animationSystem.removeEntity(object)
//
//        // remove child
//    }
//
//    func update() {
//        currentLevel?.update()
//        let entityList = Array(entities)
//        aiSystem.updateEntities()
//        renderSystem.updateEntities()
//        animationSystem.updateEntities()
//        collisionSystem.updateEntities()
//        movementSystem.updateEntities()
//        entityList.forEach({
//            $0.update()
//            // TODO update child
//        })
//    }

}

enum MultiplayerError: Error {
    case alreadyInLobby
    case cannotJoinLobby
}

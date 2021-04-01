//
//  MultiplayerServer.swift
//  paintsplash
//
//  Created by Farrell Nah on 28/3/21.
//

import Foundation

class MultiplayerServer: SinglePlayerGameManager {
    var room: RoomInfo
    var connectionHandler: ConnectionHandler
    var gameConnectionHandler: GameConnectionHandler?

    private var collisionDetector: SKCollisionDetector!

    init(roomInfo: RoomInfo, gameScene: GameScene) {
        self.room = roomInfo
        self.connectionHandler = FirebaseConnectionHandler()
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
        guard let hostId = EntityID(id: room.host.playerUUID) else {
            fatalError("Error fetching IDs of players")
        }

        player = Player(initialPosition: Vector2D.zero + Vector2D.right * 50, playerUUID: hostId)
        player.spawn()

        // set up other players
        room.players?.forEach { _, player in
            setUpGuestPlayer(player: player)
        }
    }

    func setUpGuestPlayer(player: PlayerInfo) {
        // Initialize player
        guard let playerID = EntityID(id: player.playerUUID) else {
            return
        }

        let gameId = self.room.gameID
        let newPlayer = Player(initialPosition: Vector2D.zero + Vector2D.left * 50, playerUUID: playerID)
        newPlayer.spawn()

        // Send player state updates to DB
        EventSystem.playerActionEvent.playerHealthUpdateEvent.subscribe(listener: { event in
            guard event.playerId == playerID else {
                return
            }
            self.gameConnectionHandler?.sendPlayerEvent(gameId: gameId,
                                                        playerId: playerID.id.uuidString,
                                                        action: event)
        })

        // Update player ammo
        EventSystem.playerActionEvent.playerAmmoUpdateEvent.subscribe(listener: { event in
            guard event.playerId == playerID else {
                return
            }

            self.gameConnectionHandler?.sendPlayerEvent(gameId: gameId, playerId: playerID.id.uuidString, action: event)
        })

        // Listen to user input from clients

        // Shooting input
        self.gameConnectionHandler?.observePlayerEvent(
            gameId: gameId,
            playerId: playerID.id.uuidString,
            onChange: { EventSystem.processedInputEvents.playerShootEvent.post(event: $0) }
        )

        // Movement input

        self.gameConnectionHandler?.observePlayerEvent(
            gameId: gameId,
            playerId: playerID.id.uuidString,
            onChange: { EventSystem.processedInputEvents.playerMoveEvent.post(event: $0) }
        )

        // Weapon change

        self.gameConnectionHandler?.observePlayerEvent(
            gameId: gameId,
            playerId: playerID.id.uuidString,
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
        let renderSystemPath = FirebasePaths.games + "/" + room.gameID + "/" + "RenderSystem"
        let renderSystemData = RenderSystemData(from: renderSystem)
        connectionHandler.send(
            to: renderSystemPath,
            data: renderSystemData,
            mode: .single,
            shouldRemoveOnDisconnect: false,
            onComplete: nil,
            onError: nil
        )

        let animSystemPath = FirebasePaths.games + "/" + room.gameID + "/" + "AnimSystem"
        let animationSystemData = AnimationSystemData(from: animationSystem)
        connectionHandler.send(
            to: animSystemPath,
            data: animationSystemData,
            mode: .single,
            shouldRemoveOnDisconnect: false,
            onComplete: nil,
            onError: nil
        )

        var colorables = [GameEntity: Colorable]()
        entities.forEach({ entity in
            if let colorable = entity as? Colorable {
                colorables[entity] = colorable
            }
        })

        let colorSystemPath = FirebasePaths.games + "/" + room.gameID + "/" + "ColorSystem"
        let colorSystemData = ColorSystemData(from: colorables)
        connectionHandler.send(
            to: colorSystemPath,
            data: colorSystemData,
            mode: .single,
            shouldRemoveOnDisconnect: false,
            onComplete: nil,
            onError: nil
        )
    }

    func receiveInput() {

    }

    override func update() {
        currentLevel?.update()
        aiSystem.updateEntities()
        collisionSystem.updateEntities()
        movementSystem.updateEntities()
        entities.forEach({ $0.update() })

        sendGameState()

        transformSystem.updateEntities()
        renderSystem.updateEntities()
        animationSystem.updateEntities()
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

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
        super.setUpAudio()
    }

    override func setUpPlayer() {
        let hostId = EntityID(id: room.host.playerUUID)

        player = Player(initialPosition: Vector2D.zero + Vector2D.right * 50, playerUUID: hostId)
        print(player.id)
        player.spawn()

        // set up other players
        room.players?.forEach { _, player in
            setUpGuestPlayer(player: player)
        }
    }

    func setUpGuestPlayer(player: PlayerInfo) {
        // Initialize player
        let playerID = EntityID(id: player.playerUUID)

        let gameId = self.room.gameID
        let newPlayer = Player(initialPosition: Vector2D.zero + Vector2D.left * 50, playerUUID: playerID)
        newPlayer.spawn()

        // Send player state updates to DB
        EventSystem.playerActionEvent.playerHealthUpdateEvent.subscribe(listener: { event in
            guard event.playerId == playerID else {
                return
            }
            self.gameConnectionHandler?.sendEvent(gameId: gameId,
                                                  playerId: playerID.id,
                                                  action: event)
        })

        // Update player ammo
        EventSystem.playerActionEvent.playerAmmoUpdateEvent.subscribe(listener: { event in
            guard event.playerId == playerID else {
                return
            }
            self.gameConnectionHandler?.sendEvent(gameId: gameId, playerId: playerID.id, action: event)
        })

        // Send background music information

        EventSystem.audioEvent.playMusicEvent.subscribe { event in
            guard let players = self.room.players else {
                return
            }

            guard let playerId = event.playerId else {
                players.forEach {
                    self.gameConnectionHandler?.sendEvent(gameId: gameId, playerId: $0.key, action: event)
                }
                return
            }

            self.gameConnectionHandler?.sendEvent(gameId: gameId, playerId: playerId.id, action: event)
        }

        EventSystem.audioEvent.playSoundEffectEvent.subscribe { event in
            guard let players = self.room.players else {
                return
            }

            guard let playerId = event.playerId else {
                players.forEach {
                    self.gameConnectionHandler?.sendEvent(gameId: gameId, playerId: $0.key, action: event)
                }
                return
            }

            self.gameConnectionHandler?.sendEvent(gameId: gameId, playerId: playerId.id, action: event)
        }

        // Listen to user input from clients

        // Shooting input
        self.gameConnectionHandler?.observeEvent(
            gameId: gameId,
            playerId: playerID.id,
            onChange: { EventSystem.processedInputEvents.playerShootEvent.post(event: $0) }
        )

        // Movement input
        self.gameConnectionHandler?.observeEvent(
            gameId: gameId,
            playerId: playerID.id,
            onChange: { EventSystem.processedInputEvents.playerMoveEvent.post(event: $0) }
        )

        // Weapon change
        self.gameConnectionHandler?.observeEvent(
            gameId: gameId,
            playerId: playerID.id,
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

        currentLevel = Level.getDefaultLevel(canvasManager: canvasManager, gameInfo: gameInfoManager.gameInfo)
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
        let uiEntityIDs = Set(uiEntities.map({ $0.id }))
        let entityData = EntityData(from: entities.filter({ !uiEntityIDs.contains($0.id) }))
//        let renderSystemPath = FirebasePaths.joinPaths(FirebasePaths.games, room.gameID, FirebasePaths.render_system)
        let renderablesToSend = renderSystem.renderables.filter({ entityID, _ in
            !uiEntityIDs.contains(entityID)
        })
        let renderSystemData = RenderSystemData(from: renderablesToSend)
//        connectionHandler.send(
//            to: renderSystemPath,
//            data: renderSystemData,
//            mode: .single,
//            shouldRemoveOnDisconnect: false,
//            onComplete: nil,
//            onError: nil
//        )

        let animatablesToSend = animationSystem.animatables.filter({ entityID, _ in
            !uiEntityIDs.contains(entityID)
        })
//        let animSystemPath = FirebasePaths.joinPaths(FirebasePaths.games, room.gameID, FirebasePaths.animation_system)
        let animationSystemData = AnimationSystemData(from: animatablesToSend)
//        connectionHandler.send(
//            to: animSystemPath,
//            data: animationSystemData,
//            mode: .single,
//            shouldRemoveOnDisconnect: false,
//            onComplete: nil,
//            onError: nil
//        )

        var colorables = [EntityID: Colorable]()
        entities.forEach({ entity in
            if let colorable = entity as? Colorable, !uiEntityIDs.contains(entity.id) {
                colorables[entity.id] = colorable
            }
        })

//        let colorSystemPath = FirebasePaths.joinPaths(FirebasePaths.games, room.gameID, FirebasePaths.color_system)
        let colorSystemData = ColorSystemData(from: colorables)
//        connectionHandler.send(
//            to: colorSystemPath,
//            data: colorSystemData,
//            mode: .single,
//            shouldRemoveOnDisconnect: false,
//            onComplete: nil,
//            onError: nil
//        )
        let systemData = SystemData(
            entityData: entityData,
            renderSystemData: renderSystemData,
            animationSystemData: animationSystemData,
            colorSystemData: colorSystemData
        )
        let systemPath = FirebasePaths.joinPaths(FirebasePaths.games, room.gameID, FirebasePaths.systems)
        connectionHandler.send(to: systemPath, data: systemData, mode: .single, shouldRemoveOnDisconnect: false, onComplete: nil, onError: nil)
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

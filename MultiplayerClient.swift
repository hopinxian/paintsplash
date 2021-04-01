//
//  MultiplayerClient.swift
//  paintsplash
//
//  Created by Cynthia Lee on 1/4/21.
//
import Foundation

class MultiplayerClient: GameManager {
    var uiEntities = Set<GameEntity>()

    var entities = Set<GameEntity>()
    var room: RoomInfo
    var connectionHandler: ConnectionHandler
    var gameScene: GameScene
    var gameConnectionHandler: GameConnectionHandler = FirebaseGameHandler()

    var playerInfo: PlayerInfo
    // Dummy player that allows the appropriate ammo stacks to appear
    let player = Player(initialPosition: .zero)

    var renderSystem: RenderSystem!
    var animationSystem: AnimationSystem!
    var audioSystem: AudioSystem!

    init(gameScene: GameScene, playerInfo: PlayerInfo, roomInfo: RoomInfo) {
        self.connectionHandler = FirebaseConnectionHandler()
        self.gameScene = gameScene
        self.playerInfo = playerInfo
        self.room = roomInfo

        EventSystem.entityChangeEvents.addEntityEvent.subscribe(listener: onAddEntity)
        EventSystem.entityChangeEvents.removeEntityEvent.subscribe(listener: onRemoveEntity)
        EventSystem.entityChangeEvents.addUIEntityEvent.subscribe(listener: onAddUIEntity)
        EventSystem.entityChangeEvents.removeUIEntityEvent.subscribe(listener: onRemoveUIEntity)

        assert(playerInfo.playerUUID == room.players!.first!.value.playerUUID, "Wrong uuid")
        setupGame()

        let renderSystemPath = FirebasePaths.games + "/" + room.gameID + "/" + "RenderSystem"
        connectionHandler.listen(to: renderSystemPath, callBack: updateRenderSystem)

        let animationSystemPath = FirebasePaths.games + "/" + room.gameID + "/" + "AnimSystem"
        connectionHandler.listen(to: animationSystemPath, callBack: updateAnimationSystem)

        let colorSystemPath = FirebasePaths.games + "/" + room.gameID + "/" + "ColorSystem"
        connectionHandler.listen(to: colorSystemPath, callBack: updateColorSystem)
    }

    func setupGame() {
        setUpSystems()
        setUpEntities()
        setUpUI()
        setUpAudio()
        setUpObservers()
        setUpInputListeners()
    }

    func setUpObservers() {
        guard let gameID = room.gameId else {
            return
        }

        gameConnectionHandler.observePlayerEvent(
                gameId: gameID,
                playerId: playerInfo.playerUUID,
                onChange: { EventSystem.playerActionEvent.playerHealthUpdateEvent.post(event: $0) })

        gameConnectionHandler.observePlayerEvent(
            gameId: gameID,
            playerId: playerInfo.playerUUID,
            onChange: { EventSystem.playerActionEvent.playerAmmoUpdateEvent.post(event: $0) }
        )

    func setUpSystems() {
        let renderSystem = SKRenderSystem(scene: gameScene)
        self.renderSystem = renderSystem
        animationSystem = SKAnimationSystem(renderSystem: renderSystem)
        audioSystem = AudioManager()
    }

    func setUpEntities() {

    }

    func setUpInputListeners() {
        guard let gameId = self.room.gameId else {
            print("no game id found")
            return
        }

        EventSystem.processedInputEvents.playerMoveEvent.subscribe {
            self.sendPlayerMoveEvent($0, gameId: gameId)
        }

        EventSystem.processedInputEvents.playerShootEvent.subscribe {
            self.sendPlayerShootEvent($0, gameId: gameId)
        }

        EventSystem.processedInputEvents.playerChangeWeaponEvent.subscribe {
            self.sendPlayerWeaponChangeEvent($0, gameId: gameId)
        }
    }


    private func sendPlayerMoveEvent(_ event: PlayerMoveEvent, gameId: String) {
        self.gameConnectionHandler.sendPlayerEvent(
            gameId: gameId,
            playerId: event.playerId.uuidString,
            action: event
        )
    }

    private func sendPlayerShootEvent(_ event: PlayerShootEvent, gameId: String) {
        self.gameConnectionHandler.sendPlayerEvent(
            gameId: gameId,
            playerId: event.playerId.uuidString,
            action: event
        )
    }

    private func sendPlayerWeaponChangeEvent(_ event: PlayerChangeWeaponEvent, gameId: String) {
        self.gameConnectionHandler.sendPlayerEvent(
            gameId: gameId,
            playerId: event.playerId.uuidString,
            action: event
        )
    }


    func setUpUI() {
        let background = Background()
        background.spawn()
        print("here")
        print(background.transformComponent.localPosition)

        guard let playerId = EntityID(id: playerInfo.playerUUID) else {
            fatalError("Invalid player ID")
        }

        let paintGunUI = PaintGunAmmoDisplay(weaponData: paintGun, associatedEntity: playerId)
        paintGunUI.spawn()
        paintGunUI.ammoDisplayView.animationComponent.animate(animation: WeaponAnimations.selectWeapon, interupt: true)

        guard let paintBucket = player.multiWeaponComponent.availableWeapons.compactMap({ $0 as? Bucket }).first else {
            fatalError("PaintBucket not setup properly")
        }

        let paintBucketUI = PaintBucketAmmoDisplay(weaponData: paintBucket, associatedEntity: playerId)
        paintBucketUI.spawn()
        paintBucketUI.ammoDisplayView.animationComponent.animate(
            animation: WeaponAnimations.unselectWeapon,
            interupt: true
        )

        let joystick = MovementJoystick(associatedEntityID: playerId, position: Constants.JOYSTICK_POSITION)
        joystick.spawn()

        let attackButton = AttackJoystick(associatedEntityID: playerId, position: Constants.ATTACK_BUTTON_POSITION)
        attackButton.spawn()

        // TODO: player health is currently hardcoded: should be listening to player state
        let playerHealthUI = PlayerHealthDisplay(startingHealth: 3, associatedEntityId: playerId)
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

    func setUpAudio() {

    }

    func inLobby() -> Bool {
        false
    }

    func updateGameState() {

    }

    func sendInput(event: TouchInputEvent) {

    }

    func update() {
        renderSystem.updateEntities()
        animationSystem.updateEntities()
        entities.forEach({ $0.update() })
    }

    func addObject(_ object: GameEntity) {
        entities.insert(object)
        renderSystem.addEntity(object)
        animationSystem.addEntity(object)
    }

    private func onAddEntity(event: AddEntityEvent) {
        addObject(event.entity)
    }

    func removeObject(_ object: GameEntity) {
        entities.remove(object)
        renderSystem.removeEntity(object)
        animationSystem.removeEntity(object)
    }

    private func onRemoveEntity(event: RemoveEntityEvent) {
        removeObject(event.entity)
    }

    private func onAddUIEntity(event: AddUIEntityEvent) {
        uiEntities.insert(event.entity)
        addObjectToSystems(event.entity)
    }

    private func onRemoveUIEntity(event: RemoveUIEntityEvent) {
        uiEntities.remove(event.entity)
        removeObjectFromSystems(event.entity)
    }

    private func addObjectToSystems(_ object: GameEntity) {
        renderSystem.addEntity(object)
        animationSystem.addEntity(object)
    }

    private func removeObjectFromSystems(_ object: GameEntity) {
        renderSystem.removeEntity(object)
        animationSystem.removeEntity(object)
    }

    func updateRenderSystem(data: RenderSystemData?) {
        guard let renderableData = data else {
            return
        }

        var deletedEntities = renderSystem.renderables
        renderableData.renderables.forEach({ encodedRenderable in
            if let (entity, renderable) = renderSystem.renderables.first(
                where: { $0.key == encodedRenderable.entityID }) {
                renderable.renderComponent = encodedRenderable.renderComponent
                renderable.transformComponent = encodedRenderable.transformComponent
                deletedEntities[entity] = nil
            } else {
                let newEntity = NetworkedEntity(id: encodedRenderable.entityID)
                newEntity.renderComponent = encodedRenderable.renderComponent
                newEntity.transformComponent = encodedRenderable.transformComponent
                newEntity.spawn()
                deletedEntities[newEntity.id] = nil
            }
        })

        for (_, renderable) in deletedEntities {
            renderable.destroy()
        }
    }

    func updateAnimationSystem(data: AnimationSystemData?) {
        guard let animatableData = data else {
            return
        }

        animatableData.animatables.forEach({ encodedAnimatable in
            if let (_, animatable) = animationSystem.animatables.first(
                where: { $0.key == encodedAnimatable.entityID }) {
                animatable.animationComponent = encodedAnimatable.animationComponent
            } else {
                let newEntity = NetworkedEntity(id: encodedAnimatable.entityID)
                newEntity.animationComponent = encodedAnimatable.animationComponent
                newEntity.spawn()
            }
        })
    }

    func updateColorSystem(data: ColorSystemData?) {
        guard let colorData = data else {
            return
        }

        var colorables = [GameEntity: Colorable]()
        entities.forEach({ entity in
            if let colorable = entity as? Colorable {
                colorables[entity] = colorable
            }
        })

        colorData.colorables.forEach({ encodedColorable in
            if var (_, colorable) = colorables.first(where: { $0.0.id == encodedColorable.entityID }) {
                colorable.color = encodedColorable.color
            } else {
                let newEntity = NetworkedEntity(id: encodedColorable.entityID)
                newEntity.color = encodedColorable.color
                newEntity.spawn()
            }
        })
    }
}

enum MultiplayerError: Error {
    case alreadyInLobby
    case cannotJoinLobby
}

class NetworkedEntity: GameEntity, Renderable, Animatable, Colorable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent
    var animationComponent: AnimationComponent
    var color: PaintColor

    init(id: EntityID) {
        self.renderComponent = RenderComponent(renderType: .sprite(spriteName: ""), zPosition: 0)
        self.transformComponent = TransformComponent(position: Vector2D.zero, rotation: 0, size: Vector2D.zero)
        self.animationComponent = AnimationComponent()
        self.color = .white

        super.init()

        self.id = id
    }
}

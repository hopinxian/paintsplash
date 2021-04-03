//
//  MultiplayerClient.swift
//  paintsplash
//
//  Created by Cynthia Lee on 1/4/21.
//  swiftline:disable type_body_length
import Foundation

class MultiplayerClient: GameManager {
    var uiEntities = Set<GameEntity>()
    var entities = Set<GameEntity>()
    var room: RoomInfo
    weak var gameScene: GameScene?

    var connectionHandler: ConnectionHandler = FirebaseConnectionHandler()
    var gameConnectionHandler: GameConnectionHandler =
        FirebaseGameHandler(connectionHandler: FirebaseConnectionHandler())

    var playerInfo: PlayerInfo
    // Dummy player that allows the appropriate ammo stacks to appear
    var player: Player

    var renderSystem: RenderSystem!
    var animationSystem: AnimationSystem!
    var audioSystem: AudioSystem!
    var transformSystem: TransformSystem!

    init(gameScene: GameScene, playerInfo: PlayerInfo, roomInfo: RoomInfo) {
        self.gameScene = gameScene
        self.playerInfo = playerInfo
        self.room = roomInfo

        let playerId = EntityID(id: playerInfo.playerUUID)
        self.player = Player(initialPosition: .zero, playerUUID: playerId)
        self.audioSystem = AudioManager()

        setupEventListeners()
        setupGame()
    }

    private func setupEventListeners() {
        EventSystem.entityChangeEvents
            .addEntityEvent.subscribe(listener: { [weak self] in
            self?.onAddEntity(event: $0)
        })
        EventSystem.entityChangeEvents
            .removeEntityEvent.subscribe(listener: { [weak self] in
            self?.onRemoveEntity(event: $0)
        })
        EventSystem.entityChangeEvents
            .addUIEntityEvent.subscribe(listener: { [weak self] in
            self?.onAddUIEntity(event: $0)
        })
        EventSystem.entityChangeEvents
            .removeUIEntityEvent.subscribe(listener: { [weak self] in
            self?.onRemoveUIEntity(event: $0)
        })
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
        let gameID = room.gameID

        gameConnectionHandler.observeEvent(
            gameId: gameID,
            playerId: playerInfo.playerUUID,
            onChange: {
                EventSystem.playerActionEvent.playerHealthUpdateEvent.post(event: $0)

            },
            onError: nil
        )

        gameConnectionHandler.observeEvent(
            gameId: gameID,
            playerId: playerInfo.playerUUID,
            onChange: {
                EventSystem.playerActionEvent.playerAmmoUpdateEvent.post(event: $0)
            },
            onError: nil
        )

        gameConnectionHandler.observeEvent(
            gameId: gameID,
            playerId: playerInfo.playerUUID,
            onChange: { [weak self] (event: PlayMusicEvent) in
                EventSystem.audioEvent.playMusicEvent.post(event: event)
                guard let playerId = self?.playerInfo.playerUUID else {
                    return
                }
                self?.gameConnectionHandler.acknowledgeEvent(
                    event,
                    gameId: gameID,
                    playerId: playerId,
                    onError: nil,
                    onSuccess: nil
                )
            },
            onError: nil
        )

        gameConnectionHandler.observeEvent(
            gameId: gameID,
            playerId: playerInfo.playerUUID,
            onChange: { [weak self] (event: PlaySoundEffectEvent) in
                EventSystem.audioEvent.playSoundEffectEvent.post(event: event)
                guard let playerId = self?.playerInfo.playerUUID else {
                    return
                }
                self?.gameConnectionHandler.acknowledgeEvent(
                    event,
                    gameId: gameID,
                    playerId: playerId,
                    onError: nil,
                    onSuccess: nil)
            },
            onError: nil
        )

        gameConnectionHandler.observeSystemData(gameID: gameID, callback: { [weak self] data in
            self?.updateSystemData(data: data)
        })
    }

    func setUpSystems() {
        guard let gameScene = self.gameScene else {
            fatalError("Did not set up game scene properly for multiplayer client")
        }
        let renderSystem = SKRenderSystem(scene: gameScene)
        self.renderSystem = renderSystem
        animationSystem = SKAnimationSystem(renderSystem: renderSystem)
        audioSystem = AudioManager(associatedDeviceId: player.id)
        self.transformSystem = WorldTransformSystem()
    }

    func setUpEntities() {

    }

    func setUpInputListeners() {
        let gameId = self.room.gameID

        EventSystem.processedInputEvents.playerMoveEvent.subscribe { [weak self] in
            self?.sendPlayerMoveEvent($0, gameId: gameId)
        }

        EventSystem.processedInputEvents.playerShootEvent.subscribe { [weak self] in
            self?.sendPlayerShootEvent($0, gameId: gameId)
        }

        EventSystem.processedInputEvents.playerChangeWeaponEvent.subscribe { [weak self] in
            self?.sendPlayerWeaponChangeEvent($0, gameId: gameId)
        }
    }

    private func sendPlayerMoveEvent(_ event: PlayerMoveEvent, gameId: String) {
        self.gameConnectionHandler.sendEvent(
            gameId: gameId,
            playerId: event.playerId.id,
            action: event,
            onError: nil,
            onSuccess: nil
        )
    }

    private func sendPlayerShootEvent(_ event: PlayerShootEvent, gameId: String) {
        self.gameConnectionHandler.sendEvent(
            gameId: gameId,
            playerId: event.playerId.id,
            action: event,
            onError: nil,
            onSuccess: nil
        )
    }

    private func sendPlayerWeaponChangeEvent(_ event: PlayerChangeWeaponEvent, gameId: String) {
        self.gameConnectionHandler.sendEvent(
            gameId: gameId,
            playerId: event.playerId.id,
            action: event,
            onError: nil,
            onSuccess: nil
        )
    }

    func setUpUI() {
        let background = Background()
        background.spawn()

        let playerId = EntityID(id: playerInfo.playerUUID)

        guard let paintGun = player.multiWeaponComponent
            .availableWeapons.compactMap({ $0 as? PaintGun }).first else {
            fatalError("Paintgun not setup properly")
        }

        let paintGunUI = PaintGunAmmoDisplay(weaponData: paintGun, associatedEntity: playerId)
        paintGunUI.spawn()
        paintGunUI.ammoDisplayView.animationComponent.animate(
            animation: WeaponAnimations.selectWeapon,
            interupt: true
        )

        guard let paintBucket = player.multiWeaponComponent
            .availableWeapons.compactMap({ $0 as? Bucket }).first else {
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
        self.audioSystem = AudioManager(associatedDeviceId: player.id)
        EventSystem.audioEvent
            .playMusicEvent.post(event: PlayMusicEvent(music: Music.backgroundMusic))
    }

    func update() {
        transformSystem.updateEntities()
        renderSystem.updateEntities()
        animationSystem.updateEntities()
        entities.forEach({ $0.update() })
    }

    func addObject(_ object: GameEntity) {
        entities.insert(object)
        addObjectToSystems(object)
    }

    private func onAddEntity(event: AddEntityEvent) {
        addObject(event.entity)
    }

    func removeObject(_ object: GameEntity) {
        entities.remove(object)
        removeObjectFromSystems(object)
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
        transformSystem.addEntity(object)
        renderSystem.addEntity(object)
        animationSystem.addEntity(object)
    }

    private func removeObjectFromSystems(_ object: GameEntity) {
        transformSystem.removeEntity(object)
        renderSystem.removeEntity(object)
        animationSystem.removeEntity(object)
    }

    func updateRenderSystem(data: RenderSystemData?) {
        guard let renderableData = data else {
            return
        }

        renderableData.renderables.forEach({ entity, encodedRenderable in
            if let (_, renderable) = renderSystem.renderables.first(
                    where: { $0.key == entity }) {
                renderable.renderComponent = encodedRenderable.renderComponent
                renderable.transformComponent = encodedRenderable.transformComponent
            }
        })
    }

    func updateAnimationSystem(data: AnimationSystemData?) {
        guard let animatableData = data else {
            return
        }

        animatableData.animatables.forEach({ entity, encodedAnimatable in
            if let (_, animatable) = animationSystem.animatables.first(
                    where: { $0.key == entity }) {
                animatable.animationComponent = encodedAnimatable.animationComponent
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

        colorData.colorables.forEach({ entity, encodedColorable in
            if var (_, colorable) = colorables.first(where: { $0.0.id == entity }) {
                colorable.color = encodedColorable.color
            }
        })
    }

    func updateSystemData(data: SystemData?) {
        guard let data = data else {
            return
        }

        let entityIDs = Set(entities.map({ $0.id }))

        for entity in data.entityData.entities where !entityIDs.contains(entity) {
            addNetowrkedEntity(entity: entity, data: data)
        }

        updateRenderSystem(data: data.renderSystemData)
        updateAnimationSystem(data: data.animationSystemData)
        updateColorSystem(data: data.colorSystemData)

        for entity in entityIDs where !data.entityData.entities.contains(entity) {
            entities.first(where: { gameEntity in gameEntity.id == entity })?.destroy()
        }
    }

    private func addNetowrkedEntity(entity: EntityID, data: SystemData) {
        let renderComponent =
            data.renderSystemData.renderables[entity]?.renderComponent
            ?? RenderComponent(renderType: .sprite(spriteName: ""), zPosition: 0)

        let animationComponent =
            data.animationSystemData.animatables[entity]?.animationComponent
            ?? AnimationComponent()

        let transformComponent =
            data.renderSystemData.renderables[entity]?.transformComponent
            ?? TransformComponent(position: .zero, rotation: 0, size: .zero)

        let colorComponent = data.colorSystemData.colorables[entity]?.color
            ?? .white

        let newEntity = NetworkedEntity(
            id: entity,
            renderComponent: renderComponent,
            transformComponent: transformComponent,
            animationComponent: animationComponent,
            color: colorComponent
        )
        newEntity.spawn()
    }
}

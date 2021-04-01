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
    var transformSystem: TransformSystem!

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

//        let renderSystemPath = FirebasePaths.joinPaths(FirebasePaths.games, room.gameID, FirebasePaths.render_system)
//        connectionHandler.listen(to: renderSystemPath, callBack: updateRenderSystem)
//
//        let animationSystemPath = FirebasePaths.joinPaths(FirebasePaths.games, room.gameID, FirebasePaths.animation_system)
//        connectionHandler.listen(to: animationSystemPath, callBack: updateAnimationSystem)
//
//        let colorSystemPath = FirebasePaths.joinPaths(FirebasePaths.games, room.gameID, FirebasePaths.color_system)
//        connectionHandler.listen(to: colorSystemPath, callBack: updateColorSystem)
        let systemPath = FirebasePaths.joinPaths(FirebasePaths.games, room.gameID, FirebasePaths.systems)
        connectionHandler.listen(to: systemPath, callBack: updateSystemData)
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
        gameConnectionHandler.observePlayerState(gameId: self.room.gameID,
                                                 playerId: playerInfo.playerUUID,
                                                 onChange: onPlayerStateChange )
    }

    func onPlayerStateChange(playerState: PlayerStateInfo) {
        print("CHANGED PLAYER STATE: \(playerState)")
    }

    func setUpSystems() {
        let renderSystem = SKRenderSystem(scene: gameScene)
        self.renderSystem = renderSystem
        animationSystem = SKAnimationSystem(renderSystem: renderSystem)
        audioSystem = AudioManager()
        self.transformSystem = WorldTransformSystem()
    }

    func setUpEntities() {

    }

    func setUpInputListeners() {
        EventSystem.processedInputEvents.playerMoveEvent.subscribe(listener: { event in
            self.gameConnectionHandler.sendPlayerMoveInput(gameId: self.room.gameID,
                                                           playerId: event.playerID.id.uuidString,
                                                           playerMoveEvent: event)
        })

        EventSystem.processedInputEvents.playerShootEvent.subscribe(listener: { event in
            self.gameConnectionHandler.sendPlayerShootInput(gameId: self.room.gameID,
                                                            playerId: event.playerID.id.uuidString,
                                                            playerShootEvent: event)
        })

        EventSystem.processedInputEvents.playerChangeWeaponEvent.subscribe(listener: { event in
            self.gameConnectionHandler.sendPlayerChangeWeapon(gameId: self.room.gameID,
                                                              playerId: event.playerId.id.uuidString,
                                                              changeWeaponEvent: event)
        })
    }

    func setUpUI() {
        let background = Background()
        background.spawn()

        guard let playerId = EntityID(id: playerInfo.playerUUID) else {
            fatalError("Invalid player ID")
        }

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

        gameConnectionHandler.observePlayerState(gameId: room.gameID, playerId: playerInfo.playerUUID,
                                                 onChange: handlePlayerStateUpdate)
    }

    func handlePlayerStateUpdate(playerState: PlayerStateInfo) {
        guard playerState.playerId.id.uuidString == playerInfo.playerUUID else {
            return
        }
        let health = playerState.health
        EventSystem.playerActionEvent.playerHealthUpdateEvent
            .post(event: PlayerHealthUpdateEvent(newHealth: health,
                                                 playerId: playerState.playerId))
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

        let uiEntityIDs = Set(uiEntities.map({ $0.id }))
        var deletedEntities = renderSystem.renderables.filter({ entityID, _ in
            !uiEntityIDs.contains(entityID)
        })
        renderableData.renderables.forEach({ entity, encodedRenderable in
            if let (entity, renderable) = renderSystem.renderables.first(
                where: { $0.key == entity }) {
                renderable.renderComponent = encodedRenderable.renderComponent
                renderable.transformComponent = encodedRenderable.transformComponent
                deletedEntities[entity] = nil
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

        for entity in data.entityData.entities {
            if !entityIDs.contains(entity) {
                let renderComponent = data.renderSystemData.renderables[entity]?.renderComponent
                    ?? RenderComponent(renderType: .sprite(spriteName: ""), zPosition: 0)
                let animationComponent = data.animationSystemData.animatables[entity]?.animationComponent
                    ?? AnimationComponent()
                let transformComponent = data.renderSystemData.renderables[entity]?.transformComponent
                    ?? TransformComponent(position: .zero, rotation: 0, size: .zero)
                let colorComponent = data.colorSystemData.colorables[entity]?.color
                    ?? .white
                // add entity
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

        updateRenderSystem(data: data.renderSystemData)
        updateAnimationSystem(data: data.animationSystemData)
        updateColorSystem(data: data.colorSystemData)

        for entity in entityIDs {
            if !data.entityData.entities.contains(entity) {
                // remove Entity
                entities.first(where: { gameEntity in gameEntity.id == entity })?.destroy()
            }
        }
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

    init(id: EntityID,
         renderComponent: RenderComponent,
         transformComponent: TransformComponent,
         animationComponent: AnimationComponent,
         color: PaintColor) {
        self.renderComponent = renderComponent
        self.animationComponent = animationComponent
        self.transformComponent = transformComponent
        self.color = color

        super.init()

        self.id = id
    }
}

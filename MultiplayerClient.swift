//
//  MultiplayerClient.swift
//  paintsplash
//
//  Created by Farrell Nah on 28/3/21.
//
import Foundation

class MultiplayerClient: GameManager {
    var uiEntities = Set<GameEntity>()

    var entities = Set<GameEntity>()
    var room: RoomInfo
    var connectionHandler: ConnectionHandler
    var gameScene: GameScene
    var gameConnectionHandler = FirebaseGameHandler()

    var playerInfo: PlayerInfo

    var renderSystem: RenderSystem!
    var animationSystem: AnimationSystem!

    init(room: RoomInfo,
         gameScene: GameScene,
         playerInfo: PlayerInfo) {
        self.connectionHandler = FirebaseConnectionHandler()
        self.gameScene = gameScene
        self.room = room
        self.playerInfo = playerInfo

        EventSystem.entityChangeEvents.addEntityEvent.subscribe(listener: onAddEntity)
        EventSystem.entityChangeEvents.removeEntityEvent.subscribe(listener: onRemoveEntity)
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
        setUpObservers()
        setUpInputListeners()
    }

    func setUpObservers() {
        gameConnectionHandler.observePlayerState(gameId: room.gameID,
                playerId: playerInfo.playerUUID,
                onChange: onPlayerStateChange )
    }

    func onPlayerStateChange(playerState: PlayerStateInfo) {
        print("CHANGED PLAYER STATE: \(playerState)")
    }

    func setUpSystems() {
        let renderSystem = SKRenderSystem(scene: gameScene)
        self.renderSystem = renderSystem
        self.animationSystem = SKAnimationSystem(renderSystem: renderSystem)
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
            print("player has changed weapon. send to firebase")
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
        // let playerHealthUI = PlayerHealthDisplay(startingHealth: player.healthComponent.currentHealth)

        // TODO: player health is currently hardcoded

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
        guard playerState.playerId.id.uuidString
                == playerInfo.playerUUID else {
            return
        }
        let health = playerState.health
        EventSystem.playerActionEvent.playerHealthUpdateEvent.post(event: PlayerHealthUpdateEvent(newHealth: health,
                playerId: playerState.playerId))
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

    func sendInput(event: TouchInputEvent) {

    }

    func update() {
        renderSystem.updateEntities()
        animationSystem.updateEntities()
        entities.forEach({ $0.update() })
    }

    private func onAddEntity(event: AddEntityEvent) {
        addObject(event.entity)
    }

    func addObject(_ object: GameEntity) {
        entities.insert(object)
        renderSystem.addEntity(object)
        animationSystem.addEntity(object)
    }

    private func onRemoveEntity(event: RemoveEntityEvent) {
        removeObject(event.entity)
    }

    func removeObject(_ object: GameEntity) {
        entities.remove(object)
        renderSystem.removeEntity(object)
        animationSystem.removeEntity(object)
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

//
//  MultiplayerClient.swift
//  paintsplash
//
//  Created by Cynthia Lee on 1/4/21.
//  swiftline:disable type_body_length
import Foundation

class MultiplayerClient: SinglePlayerGameManager {
    var room: RoomInfo

    var connectionHandler: ConnectionHandler = FirebaseConnectionHandler()
    var gameConnectionHandler: GameConnectionHandler =
        PaintSplashGameHandler(connectionHandler: FirebaseConnectionHandler())

    var playerInfo: PlayerInfo

    init(gameScene: GameScene, playerInfo: PlayerInfo, roomInfo: RoomInfo) {
        self.playerInfo = playerInfo
        self.room = roomInfo

        super.init(gameScene: gameScene)
    }

    override func setupGame() {
        super.setupGame()
        setUpObservers()
        setUpInputListeners()
    }

    override func setUpPlayer() {
        player = Player(
            initialPosition: Vector2D.zero + Vector2D.right * 50,
            playerUUID: EntityID(id: playerInfo.playerUUID)
        )
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
            onChange: { (event: PlayerChangedWeaponEvent) in
                EventSystem.playerActionEvent.playerChangedWeaponEvent.post(event: event)
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

    override func setUpSystems() {
        super.setUpSystems()
        audioManager = AudioManager(associatedDeviceId: EntityID(id: playerInfo.playerUUID))
    }

    override func setUpEntities() {

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

    override func update() {
        transformSystem.updateEntities()
        renderSystem.updateEntities()
        animationSystem.updateEntities()
        entities.forEach({ $0.update() })
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
                renderable.renderComponent.wasModified = true
                renderable.transformComponent.wasModified = true
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
                animatable.animationComponent.animationToPlay = encodedAnimatable.animationComponent.currentAnimation
                animatable.animationComponent.wasModified = true
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
        print("received")
        guard let data = data else {
            return
        }

        let entityIDs = Set(entities.map({ $0.id }))

        for entity in data.entityData.entities where !entityIDs.contains(entity) {
            addNetowrkedEntity(entity: entity, data: data)
        }

        var colorables = [EntityID: Colorable]()
        entities.forEach({ entity in
            if let colorable = entity as? Colorable {
                colorables[entity.id] = colorable
            }
        })

        for entity in data.entityData.entities {
            if let renderable = data.renderSystemData?.renderables[entity] {
                let renderComponent = renderable.renderComponent
                let transformComponent = renderable.transformComponent
                renderComponent.wasModified = true
                transformComponent.wasModified = true
                renderSystem.renderables[entity]?.renderComponent = renderComponent
                renderSystem.renderables[entity]?.transformComponent = transformComponent
            }

            if let animatable = data.animationSystemData?.animatables[entity] {
                let animationComponent = animatable.animationComponent
                animationComponent.wasModified = true
                animationComponent.animationToPlay = animationComponent.currentAnimation
                animationSystem.animatables[entity]?.animationComponent = animationComponent
            }

            if let colorable = data.colorSystemData?.colorables[entity] {
                let color = colorable.color
                colorables[entity]?.color = color
            }
        }
//        updateRenderSystem(data: data.renderSystemData)
//        updateAnimationSystem(data: data.animationSystemData)
//        updateColorSystem(data: data.colorSystemData)

        for entity in entityIDs where !data.entityData.entities.contains(entity) {
            entities.first(where: { gameEntity in gameEntity.id == entity })?.destroy()
        }
    }

    private func addNetowrkedEntity(entity: EntityID, data: SystemData) {
        let renderComponent =
            data.renderSystemData?.renderables[entity]?.renderComponent

        let animationComponent =
            data.animationSystemData?.animatables[entity]?.animationComponent

        let transformComponent =
            data.renderSystemData?.renderables[entity]?.transformComponent

        let colorComponent = data.colorSystemData?.colorables[entity]?.color

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

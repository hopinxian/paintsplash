//
//  MultiplayerClient.swift
//  paintsplash
//
//  Created by Farrell Nah on 28/3/21.
//
import Foundation

class MultiplayerClient: GameManager {
    var entities = Set<GameEntity>()
    var room: RoomInfo
    var connectionHandler: ConnectionHandler
    var gameScene: GameScene

    var renderSystem: RenderSystem!
    var animationSystem: AnimationSystem!

    init(room: RoomInfo, gameScene: GameScene) {
        self.connectionHandler = FirebaseConnectionHandler()
        self.gameScene = gameScene
        self.room = room


        EventSystem.entityChangeEvents.addEntityEvent.subscribe(listener: onAddEntity)
        EventSystem.entityChangeEvents.removeEntityEvent.subscribe(listener: onRemoveEntity)

        setupGame()

        let renderSystemPath = FirebasePaths.games + "/" + room.gameID + "/" + "RenderSystem"
        connectionHandler.listen(to: renderSystemPath, callBack: updateRenderSystem)

        let animationSystemPath = FirebasePaths.games + "/" + room.gameID + "/" + "AnimSystem"

        connectionHandler.listen(to: animationSystemPath, callBack: updateAnimationSystem)
    }

    func setupGame() {
        setUpSystems()
        setUpEntities()
        setUpUI()
    }

    func setUpSystems() {
        let renderSystem = SKRenderSystem(scene: gameScene)
        self.renderSystem = renderSystem
        animationSystem = SKAnimationSystem(renderSystem: renderSystem)
    }

    func setUpEntities() {

    }

    func setUpUI() {

    }
    
    func inLobby() -> Bool {
        return false
    }

    func updateRenderSystem(data: RenderSystemData?) {
        guard let renderableData = data else {
            return
        }

        renderableData.renderables.forEach({ encodedRenderable in
            if let (_, renderable) = renderSystem.renderables.first(where: { $0.key.id == encodedRenderable.entityID }) {
                renderable.renderComponent = encodedRenderable.renderComponent
                renderable.transformComponent = encodedRenderable.transformComponent
            } else {
                let newEntity = NetworkedEntity(id: encodedRenderable.entityID)
                newEntity.renderComponent = encodedRenderable.renderComponent
                newEntity.transformComponent = encodedRenderable.transformComponent
                newEntity.spawn()
            }
        })
    }

    func updateAnimationSystem(data: AnimationSystemData?) {
        guard let animatableData = data else {
            return
        }

        animatableData.animatables.forEach({ encodedAnimatable in
            if let (_, animatable) = animationSystem.animatables.first(where: { $0.key.id == encodedAnimatable.entityID }) {
                animatable.animationComponent = encodedAnimatable.animationComponent
            } else {
                let newEntity = NetworkedEntity(id: encodedAnimatable.entityID)
                newEntity.animationComponent = encodedAnimatable.animationComponent
                newEntity.spawn()
            }
        })
    }

    func sendInput(event: TouchInputEvent) {

    }

    func update() {
        renderSystem.updateEntities()
        animationSystem.updateEntities()
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

class NetworkedEntity: GameEntity, Renderable, Animatable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent
    var animationComponent: AnimationComponent

    init(id: UUID) {
        self.renderComponent = RenderComponent(renderType: .sprite(spriteName: ""), zPosition: 0)
        self.transformComponent = TransformComponent(position: Vector2D.zero, rotation: 0, size: Vector2D.zero)
        self.animationComponent = AnimationComponent()

        super.init()

        self.id = id
    }
}

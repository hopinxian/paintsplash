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

        let colorSystemPath = FirebasePaths.games + "/" + room.gameID + "/" + "ColorSystem"
        connectionHandler.listen(to: colorSystemPath, callBack: updateColorSystem)
    }

    func setupGame() {
        setUpSystems()
        setUpEntities()
        setUpUI()
    }

    func setUpSystems() {
        let renderSystem = SKRenderSystem(scene: gameScene)
        self.renderSystem = renderSystem
        self.animationSystem = SKAnimationSystem(renderSystem: renderSystem)
    }

    func setUpEntities() {

    }

    func setUpUI() {

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

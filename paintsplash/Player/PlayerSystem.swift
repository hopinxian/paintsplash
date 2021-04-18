//
//  UserInputSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//
protocol PlayerSystem: System {
    var players: [EntityID: PlayableCharacter] { get set }
    var processedInputEvents: [ProcessedInputEvent] { get set }

}

class PaintSplashPlayerSystem: PlayerSystem {
    var players = [EntityID: PlayableCharacter]()
    var processedInputEvents = [ProcessedInputEvent]()

    init() {
        EventSystem.processedInputEvents.subscribe(listener: { [weak self] in self?.addEvent(event: $0) })
    }

    func addEntity(_ entity: GameEntity) {
        if let player = entity as? PlayableCharacter {
            players[entity.id] = player
        }
    }

    func removeEntity(_ entity: GameEntity) {
        players[entity.id] = nil
    }

    func updateEntities(_ deltaTime: Double) {
        for (_, player) in players where player.playableComponent.active {
            for event in processedInputEvents {
                sendEvent(event: event, to: player)
            }
        }

        processedInputEvents = []
    }

    private func sendEvent(event: ProcessedInputEvent, to entity: PlayableCharacter) {
        switch event {
        case let playerMoveEvent as PlayerMoveEvent:
            entity.playableComponent.onMove(event: playerMoveEvent)
        case let playerShootEvent as PlayerShootEvent:
            entity.playableComponent.onShoot(event: playerShootEvent)
        case let playerAimEvent as PlayerAimEvent:
            entity.playableComponent.onAim(event: playerAimEvent)
        case let playerChangeWeaponEvent as PlayerChangeWeaponEvent:
            entity.playableComponent.onWeaponChange(event: playerChangeWeaponEvent)
        default:
            fatalError("Unimplemented ProcessedInputEvent")
        }
    }

    private func addEvent(event: ProcessedInputEvent) {
        processedInputEvents.append(event)
    }

    func readClientPlayerData(data: SystemData?) {
//        guard let data = data else {
//            return
//        }
//        let clientId = data.entityData.entities[0]
//        if let client = entities.first(where: { $0.id.id == clientId.id }) as? Player,
//            let transformComponent = data.renderSystemData?.renderables[clientId]?.transformComponent,
//            let animationComponent = data.animationSystemData?.animatables[clientId]?.animationComponent,
//            let renderComponent = data.renderSystemData?.renderables[clientId]?.renderComponent {
//            let boundedComponent = BoundedTransformComponent(
//                position: transformComponent.worldPosition,
//                rotation: transformComponent.rotation,
//                size: transformComponent.size,
//                bounds: Constants.PLAYER_MOVEMENT_BOUNDS)
//            client.transformComponent = boundedComponent
//            client.renderComponent = renderComponent
//            client.animationComponent = animationComponent
//        }
    }
}

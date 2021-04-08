//
//  UserInputSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//
protocol PlayerSystem: System {
    var players: [EntityID: PlayableCharacter] { get set }
    var onMoveEvents: [PlayerMoveEvent] { get set }
    var onShootEvents: [PlayerShootEvent] { get set }
    var onWeaponChangeEvents: [PlayerChangeWeaponEvent] { get set }
}

class PaintSplashPlayerSystem: PlayerSystem {
    var players = [EntityID: PlayableCharacter]()
    var onMoveEvents = [PlayerMoveEvent]()
    var onShootEvents = [PlayerShootEvent]()
    var onWeaponChangeEvents = [PlayerChangeWeaponEvent]()

    init() {
        EventSystem.processedInputEvents.playerMoveEvent.subscribe(listener: onMove)
        EventSystem.processedInputEvents.playerShootEvent.subscribe(listener: onShoot)
        EventSystem.processedInputEvents.playerChangeWeaponEvent.subscribe(listener: onChangeWeapon)
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
        for (_, player) in players {
            for event in onMoveEvents {
                player.playableComponent.onMove(event: event)
            }
            for event in onShootEvents {
                player.playableComponent.onShoot(event: event)
            }
            for event in onWeaponChangeEvents {
                player.playableComponent.onWeaponChange(event: event)
            }
        }
        onMoveEvents = []
        onShootEvents = []
        onWeaponChangeEvents = []
    }

    func onMove(event: PlayerMoveEvent) {
        onMoveEvents.append(event)
    }

    func onShoot(event: PlayerShootEvent) {
        onShootEvents.append(event)
    }

    func onChangeWeapon(event: PlayerChangeWeaponEvent) {
        onWeaponChangeEvents.append(event)
    }
}

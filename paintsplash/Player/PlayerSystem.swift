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
    var onBombEvents: [PlayerBombEvent] { get set }
}

class PaintSplashPlayerSystem: PlayerSystem {
    var players = [EntityID: PlayableCharacter]()
    var onMoveEvents = [PlayerMoveEvent]()
    var onAimEvents = [PlayerAimEvent]()
    var onShootEvents = [PlayerShootEvent]()
    var onWeaponChangeEvents = [PlayerChangeWeaponEvent]()
    var onBombEvents = [PlayerBombEvent]()
    
    let eventLimit = 100

    init() {
        EventSystem.processedInputEvents.playerMoveEvent.subscribe(listener: { [weak self] in self?.onMove(event: $0) })
        EventSystem.processedInputEvents.playerAimEvent.subscribe(listener: { [weak self] in self?.onAim(event: $0) })
        EventSystem.processedInputEvents.playerShootEvent.subscribe(listener: { [weak self] in self?.onShoot(event: $0) })
        EventSystem.processedInputEvents.playerChangeWeaponEvent.subscribe(listener: { [weak self] in self?.onChangeWeapon(event: $0) })
        EventSystem.processedInputEvents.playerBombEvent.subscribe(listener: { [weak self] in self?.onBomb(event: $0) })
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
            for event in onAimEvents {
                player.playableComponent.onAim(event: event)
            }
            for event in onShootEvents {
                player.playableComponent.onShoot(event: event)
            }
            for event in onWeaponChangeEvents {
                player.playableComponent.onWeaponChange(event: event)
            }
            for event in onBombEvents {
                player.playableComponent.onBomb(event: event)
            }
        }
        onMoveEvents = []
        onAimEvents = []
        onShootEvents = []
        onWeaponChangeEvents = []
        onBombEvents = []
    }

    func onMove(event: PlayerMoveEvent) {
        if onMoveEvents.count < eventLimit {
            onMoveEvents.append(event)
        }
    }

    func onAim(event: PlayerAimEvent) {
        if onAimEvents.count < eventLimit {
            onAimEvents.append(event)
        }
    }

    func onShoot(event: PlayerShootEvent) {
        if onShootEvents.count < eventLimit {
            onShootEvents.append(event)
        }
    }

    func onChangeWeapon(event: PlayerChangeWeaponEvent) {
        onWeaponChangeEvents.append(event)
    }

    func onBomb(event: PlayerBombEvent) {
        onBombEvents.append(event)
    }
}

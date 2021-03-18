//
//  ProcessedInputEventManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

class ProcessedInputEventManager: EventManager<ProcessedInputEvent> {
    let playerShootEvent = EventManager<PlayerShootEvent>()
    let playerMoveEvent = EventManager<PlayerMoveEvent>()
    let playerChangeWeaponEvent = EventManager<PlayerChangeWeaponEvent>()

    override func subscribe(listener: @escaping (ProcessedInputEvent) -> Void) {
        super.subscribe(listener: listener)
        playerShootEvent.subscribe(listener: listener)
        playerMoveEvent.subscribe(listener: listener)
        playerChangeWeaponEvent.subscribe(listener: listener)
    }
}

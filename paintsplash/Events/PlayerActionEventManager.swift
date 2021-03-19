//
//  PlayerActionEventManager.swift
//  paintsplash
//
//  Created by Praveen Bala on 17/3/21.
//

class PlayerActionEventManager: EventManager<PlayerActionEvent> {
    let playerMovementEvent = EventManager<PlayerMovementEvent>()
    let playerAttackEvent = EventManager<PlayerAttackEvent>()
    let playerHealthUpdateEvent = EventManager<PlayerHealthUpdateEvent>()

    override func subscribe(listener: @escaping (PlayerActionEvent) -> Void) {
        super.subscribe(listener: listener)
        playerMovementEvent.subscribe(listener: listener)
        playerAttackEvent.subscribe(listener: listener)
        playerHealthUpdateEvent.subscribe(listener: listener)
    }
}

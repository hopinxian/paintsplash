//
//  PlayerActionEventManager.swift
//  paintsplash
//
//  Created by Praveen Bala on 17/3/21.
//

class PlayerActionEventManager: EventManager<PlayerActionEvent> {
    let playerMovementEvent = EventManager<PlayerMovementEvent>()
//    let playerAttackEvent = EventManager<PlayerAttackEvent>()
    let playerHealthUpdateEvent = EventManager<PlayerHealthUpdateEvent>()
    let playerAmmoUpdateEvent = EventManager<PlayerAmmoUpdateEvent>()
    let playerChangedWeaponEvent = EventManager<PlayerChangedWeaponEvent>()

    override func subscribe(listener: @escaping (PlayerActionEvent) -> Void) {
        super.subscribe(listener: listener)
        playerMovementEvent.subscribe(listener: listener)
//        playerAttackEvent.subscribe(listener: listener)
        playerHealthUpdateEvent.subscribe(listener: listener)
        playerAmmoUpdateEvent.subscribe(listener: listener)
        playerChangedWeaponEvent.subscribe(listener: listener)
    }
}

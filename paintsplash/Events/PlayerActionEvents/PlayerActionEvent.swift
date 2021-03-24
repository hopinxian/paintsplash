//
//  PlayerActionEvent.swift
//  paintsplash
//
//  Created by Praveen Bala on 17/3/21.
//

class PlayerActionEvent: Event {

}

class PlayerMovementEvent: PlayerActionEvent {
    let location: Vector2D

    init(location: Vector2D) {
        self.location = location
    }
}

class PlayerAttackEvent: PlayerActionEvent {

}

class PlayerHealthUpdateEvent: PlayerActionEvent {
    let newHealth: Int

    init(newHealth: Int) {
        self.newHealth = newHealth
    }
}

class PlayerAmmoUpdateEvent: PlayerActionEvent {
    let weapon: Weapon
    let ammo: [Ammo]

    init(weapon: Weapon, ammo: [Ammo]) {
        self.weapon = weapon
        self.ammo = ammo
    }
}

class PlayerChangedWeaponEvent: PlayerActionEvent {
    let weapon: Weapon

    init(weapon: Weapon) {
        self.weapon = weapon
    }
}

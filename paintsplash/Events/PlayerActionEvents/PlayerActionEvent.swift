//
//  PlayerActionEvent.swift
//  paintsplash
//
//  Created by Praveen Bala on 17/3/21.
//
//

import Foundation

class PlayerActionEvent: Event {

}

class PlayerMovementEvent: PlayerActionEvent {
    let playerId: UUID
    let location: Vector2D

    init(location: Vector2D, playerId: UUID) {
        self.location = location
        self.playerId = playerId
    }
}

class PlayerAttackEvent: PlayerActionEvent {

}

class PlayerHealthUpdateEvent: PlayerActionEvent {
    let newHealth: Int
    let playerId: UUID

    init(newHealth: Int, playerId: UUID) {
        self.newHealth = newHealth
        self.playerId = playerId
    }
}

class PlayerAmmoUpdateEvent: PlayerActionEvent {
    let weapon: Weapon
    let ammo: [Ammo]
    let playerId: UUID

    init(weapon: Weapon, ammo: [Ammo], playerId: UUID) {
        self.weapon = weapon
        self.ammo = ammo
        self.playerId = playerId
    }
}

class PlayerChangedWeaponEvent: PlayerActionEvent {
    let weapon: Weapon
    let playerId: UUID

    init(weapon: Weapon, playerId: UUID) {
        self.weapon = weapon
        self.playerId = playerId
    }
}

//
//class PlayerActionEvent: Event {
//
//}
//
//class PlayerMovementEvent: PlayerActionEvent {
//    let location: Vector2D
//    let playerId: UUID
//
//    init(location: Vector2D, playerId: UUID) {
//        self.location = location
//        self.playerId = playerId
//    }
//}
//
//class PlayerAttackEvent: PlayerActionEvent {
//
//}
//
//class PlayerHealthUpdateEvent: PlayerActionEvent {
//    let newHealth: Int
//    let playerId: UUID
//
//    init(newHealth: Int, playerId: UUID) {
//        self.newHealth = newHealth
//        self.playerId = playerId
//    }
//}
//
//class PlayerAmmoUpdateEvent: PlayerActionEvent {
//    let weapon: Weapon
//    let ammo: [Ammo]
//    let playerId: UUID
//
//    init(weapon: Weapon, ammo: [Ammo], playerId: UUID) {
//        self.weapon = weapon
//        self.ammo = ammo
//        self.playerId = playerId
//    }
//}
//
//class PlayerChangedWeaponEvent: PlayerActionEvent {
//    let weapon: Weapon
//    let playerId: UUID
//
//    init(weapon: Weapon, playerId: UUID) {
//        self.weapon = weapon
//        self.playerId = playerId
//    }
//}

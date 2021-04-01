//
//  ProcessedInputEvent.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

import Foundation

class ProcessedInputEvent: Event {
}

class PlayerMoveEvent: ProcessedInputEvent, Codable {
    let direction: Vector2D
    let playerID: EntityID

    init(direction: Vector2D, playerID: EntityID) {
        self.direction = direction
        self.playerID = playerID
    }
}

class PlayerShootEvent: ProcessedInputEvent, Codable {
    let direction: Vector2D
    let playerID: EntityID

    init(direction: Vector2D, playerID: EntityID) {
        self.direction = direction
        self.playerID = playerID
    }
}

class PlayerChangeWeaponEvent: ProcessedInputEvent {
    let newWeapon: Weapon.Type

    init(newWeapon: Weapon.Type) {
        self.newWeapon = newWeapon
    }
}

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
    let playerId: EntityID

    init(direction: Vector2D, playerID: EntityID) {
        self.direction = direction
        self.playerId = playerID
    }
}

class PlayerShootEvent: ProcessedInputEvent, Codable {
    let direction: Vector2D
    let playerId: EntityID

    init(direction: Vector2D, playerID: EntityID) {
        self.direction = direction
        self.playerId = playerID
    }
}

class PlayerChangeWeaponEvent: ProcessedInputEvent, Codable {
    let newWeapon: Weapon.Type
    let playerId: EntityID
    let weaponType: WeaponType?

    init(newWeapon: Weapon.Type, playerId: EntityID) {
        self.newWeapon = newWeapon
        self.playerId = playerId
        self.weaponType = WeaponType.toEnum(newWeapon)
    }

    enum CodingKeys: String, CodingKey {
        case playerId, weaponType
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        playerId = try values.decode(EntityID.self, forKey: .playerId)
        weaponType = try values.decode(WeaponType.self, forKey: .weaponType)
        guard let type = weaponType,
              let newWeaponType = type.toWeapon() else {
            fatalError("Cannot decode")
        }

        newWeapon = newWeaponType
    }
}

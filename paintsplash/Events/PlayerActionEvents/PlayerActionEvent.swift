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
    let playerId: EntityID
    let location: Vector2D

    init(location: Vector2D, playerId: EntityID) {
        self.location = location
        self.playerId = playerId
    }
}

class PlayerAttackEvent: PlayerActionEvent {

}

class PlayerHealthUpdateEvent: PlayerActionEvent, Codable {
    let newHealth: Int
    let playerId: EntityID

    init(newHealth: Int, playerId: EntityID) {
        self.newHealth = newHealth
        self.playerId = playerId
    }
}

class PlayerAmmoUpdateEvent: PlayerActionEvent, Codable {
    let weaponType: Weapon.Type
    let ammo: [Ammo]
    let playerId: EntityID
    private let weaponTypeEnum: WeaponType?

    init(weaponType: Weapon.Type, ammo: [Ammo], playerId: EntityID) {
        self.weaponType = weaponType
        self.ammo = ammo
        self.playerId = playerId
        weaponTypeEnum = WeaponType.toEnum(weaponType)
    }

    enum CodingKeys: String, CodingKey {
        case playerId, weaponTypeEnum, ammo
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(playerId, forKey: .playerId)
        try container.encode(weaponTypeEnum, forKey: .weaponTypeEnum)
        let codableAmmo = ammo.compactMap { $0 as? PaintAmmo }
        try container.encode(codableAmmo, forKey: .ammo)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        playerId = try values.decode(EntityID.self, forKey: .playerId)
        let paintAmmo = try? values.decode([PaintAmmo].self, forKey: .ammo) // TODO: Change [PaintAmmo] to [Ammo]
        ammo = paintAmmo ?? []
        weaponTypeEnum = try values.decode(WeaponType.self, forKey: .weaponTypeEnum)
        guard let type = weaponTypeEnum,
              let eventWeaponType = type.toWeapon() else {
            fatalError("Cannot decode")
        }
        weaponType = eventWeaponType
    }
}

class PlayerChangedWeaponEvent: PlayerActionEvent {
    let weapon: Weapon
    let playerId: EntityID

    init(weapon: Weapon, playerId: EntityID) {
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

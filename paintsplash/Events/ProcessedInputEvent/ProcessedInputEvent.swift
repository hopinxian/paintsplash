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
    let playerId: UUID

    init(direction: Vector2D, playerID: UUID) {
        self.direction = direction
        self.playerId = playerID
    }
}

class PlayerShootEvent: ProcessedInputEvent, Codable {
    let direction: Vector2D
    let playerId: UUID

    init(direction: Vector2D, playerID: UUID) {
        self.direction = direction
        self.playerId = playerID
    }
}

//class PlayerChangeWeaponEvent: ProcessedInputEvent {
//    let newWeapon: Weapon.Type
//    let playerID: UUID
//
//    init(newWeapon: Weapon.Type, playerID: UUID) {
//        self.newWeapon = newWeapon
//        self.playerID = playerID
//    }
//}


class PlayerChangeWeaponEvent: ProcessedInputEvent, Codable {
    let newWeapon: Weapon.Type
    let playerId: UUID
    let weaponType: WeaponType?

    init(newWeapon: Weapon.Type, playerId: UUID) {
        self.newWeapon = newWeapon
        self.playerId = playerId
        self.weaponType = WeaponType.toEnum(newWeapon)
    }

    enum CodingKeys: String, CodingKey {
        case playerId, weaponType
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        playerId = try values.decode(UUID.self, forKey: .playerId)
        weaponType = try values.decode(WeaponType.self, forKey: .weaponType)
        guard let type = weaponType,
              let newWeaponType = type.toWeapon() else {
            fatalError("Cannot decode")
        }

        newWeapon = newWeaponType
    }
}

enum WeaponType: String, Codable {
    case paintgun
    case bucket

    static func toEnum(_ type: Weapon.Type) -> WeaponType? {
        switch type {
        case is PaintGun.Type:
            return .paintgun
        case is Bucket.Type:
            return.bucket
        default:
            return nil
        }
    }

    func toWeapon() -> Weapon.Type? {
        switch self {
        case .paintgun:
            return PaintGun.self
        case .bucket:
            return Bucket.self
        }
    }
}

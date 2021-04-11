//
//  ProcessedInputEvent.swift
//  paintsplash
//
//  Created by Farrell Nah on 15/3/21.
//

import Foundation

class ProcessedInputEvent: Event, Comparable {
    static func < (lhs: ProcessedInputEvent, rhs: ProcessedInputEvent) -> Bool {
        guard let lhsId = lhs.inputId,
              let rhsId = rhs.inputId else {
            return false
        }
        return lhsId < rhsId
    }

    var inputId: InputId?

    init() {
        self.inputId = nil
    }

    init(counter: InputId) {
        self.inputId = counter
    }
}

class InputId: Hashable, Codable, Comparable {
    static func < (lhs: InputId, rhs: InputId) -> Bool {
        lhs.id < rhs.id
    }

    static func == (lhs: InputId, rhs: InputId) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static var counter = 1
    let id: Int

    init() {
        self.id = InputId.counter
        InputId.counter += 1
    }

    init(_ id: Int) {
        self.id = id
    }
}

class PlayerMoveEvent: ProcessedInputEvent, Codable {
    let direction: Vector2D
    let playerId: EntityID

    init(direction: Vector2D, playerID: EntityID) {
        self.direction = direction
        self.playerId = playerID
        super.init()
    }

    init(direction: Vector2D, playerID: EntityID, inputId: InputId) {
        self.direction = direction
        self.playerId = playerID
        super.init(counter: inputId)
    }
}

class PlayerShootEvent: ProcessedInputEvent, Codable {
    let direction: Vector2D
    let playerId: EntityID

    init(direction: Vector2D, playerID: EntityID) {
        self.direction = direction
        self.playerId = playerID
        super.init()
    }

    init(direction: Vector2D, playerID: EntityID, inputId: InputId) {
        self.direction = direction
        self.playerId = playerID
        super.init(counter: inputId)
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
        super.init()
    }

    init(newWeapon: Weapon.Type, playerId: EntityID, inputId: InputId) {
        self.newWeapon = newWeapon
        self.playerId = playerId
        self.weaponType = WeaponType.toEnum(newWeapon)
        super.init(counter: inputId)
    }

    enum CodingKeys: String, CodingKey {
        case playerId, weaponType, inputId
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(inputId, forKey: .inputId)
        try container.encode(playerId, forKey: .playerId)
        try container.encode(weaponType, forKey: .weaponType)
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        playerId = try values.decode(EntityID.self, forKey: .playerId)
        weaponType = try values.decode(WeaponType.self, forKey: .weaponType)
        let inputId = try values.decode(InputId.self, forKey: .inputId)
        guard let type = weaponType,
              let newWeaponType = type.toWeapon() else {
            fatalError("Cannot decode")
        }

        newWeapon = newWeaponType
        super.init(counter: inputId)
    }
}

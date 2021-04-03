//
//  WeaponType.swift
//  paintsplash
//
//  Created by Farrell Nah on 4/4/21.
//

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

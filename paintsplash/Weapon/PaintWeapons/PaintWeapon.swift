//
//  PaintWeapon.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//

class PaintWeapon: Weapon {
    typealias AmmoType = PaintAmmo

    func load(_ ammo: [PaintAmmo]) {
        return
    }

    func shoot() -> Projectile? {
        return nil
    }

    func canShoot() -> Bool {
        true
    }
}

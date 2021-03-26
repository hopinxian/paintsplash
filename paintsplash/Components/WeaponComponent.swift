//
//  WeaponComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class WeaponComponent: Component, Weapon {
    var capacity: Int
    var carriedBy: Transformable?

    init(capacity: Int) {
        self.capacity = capacity
    }

    func load(_ ammo: [Ammo]) {

    }
    func shoot(in direction: Vector2D) -> Projectile? {
        nil
    }
    func canShoot() -> Bool {
        false
    }
    func getAmmo() -> [Ammo] {
        []
    }
    func canLoad(_ ammo: [Ammo]) -> Bool {
        false
    }
}

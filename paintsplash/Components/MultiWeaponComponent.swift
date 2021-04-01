//
//  MultiWeaponComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class MultiWeaponComponent: WeaponComponent {
    var activeWeapon: Weapon
    var availableWeapons: [Weapon]
    override var carriedBy: Transformable? {
        didSet {
            for weapon in availableWeapons {
                weapon.carriedBy = carriedBy
            }
        }
    }

    init(weapons: [Weapon]) {
        self.activeWeapon = weapons[0]
        self.availableWeapons = weapons
        super.init(capacity: activeWeapon.capacity)
    }

    override func load(_ ammo: [Ammo]) {
        activeWeapon.load(ammo)
    }

    func load<T: Weapon>(to weaponType: T.Type, ammo: [Ammo]) {
        guard let weapon = availableWeapons.compactMap({ $0 as? T }).first else {
            return
        }

        weapon.load(ammo)
    }

    override func shoot(from position: Vector2D, in direction: Vector2D) -> Projectile? {
        // Handle shooting here
        guard let projectile = activeWeapon.shoot(from: position, in: direction),
            let carriedBy = carriedBy else {
            return nil
        }

        projectile.spawn()

        return projectile
    }

    func switchWeapon<T: Weapon>(to weapon: T.Type) -> Weapon? {
        guard let weapon = availableWeapons.compactMap({ $0 as? T }).first else {
            return nil
        }

        activeWeapon = weapon
        capacity = weapon.capacity
        return activeWeapon
    }

    override func canShoot() -> Bool {
        activeWeapon.canShoot()
    }

    override func getAmmo() -> [Ammo] {
        activeWeapon.getAmmo()
    }

    func getAmmo() -> [(Weapon, [Ammo])] {
        var ammoList = [(Weapon, [Ammo])]()
        for weapon in availableWeapons {
            ammoList.append((weapon, weapon.getAmmo()))
        }
        return ammoList
    }

    override func canLoad(_ ammo: [Ammo]) -> Bool {
        activeWeapon.canLoad(ammo)
    }
}

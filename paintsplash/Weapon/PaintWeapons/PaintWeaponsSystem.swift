//
//  WeaponSystemImpl.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//

class PaintWeaponsSystem: MultiWeaponSystem {
    var activeWeapon: Weapon?
    var availableWeapons: [Weapon]
    var carriedBy: Transformable?

    init(weapons: [Weapon]) {
        self.activeWeapon = weapons[0]
        self.availableWeapons = weapons
    }
    
    func load(_ ammo: [Ammo]) {
        guard let weapon = activeWeapon else {
            return
        }
        
        weapon.load(ammo)
        EventSystem.playerAmmoUpdateEvent.post(event: PlayerAmmoUpdateEvent(weapon: weapon, ammo: weapon.getAmmo()))
    }

    func load<T: Weapon>(to weaponType: T.Type, ammo: [Ammo]) {
        guard let weapon = availableWeapons.compactMap({ $0 as? T }).first else {
            return
        }

        weapon.load(ammo)
        EventSystem.playerAmmoUpdateEvent.post(event: PlayerAmmoUpdateEvent(weapon: weapon, ammo: weapon.getAmmo()))
    }

    func shoot(in direction: Vector2D) -> Bool {

        // Handle shooting here
        guard let weapon = activeWeapon,
              let projectile = weapon.shoot(in: direction),
              let carriedBy = carriedBy else {
            return false
        }

        projectile.move(to: carriedBy.transform.position)

        EventSystem.entityChangeEvents.addEntityEvent.post(event: AddEntityEvent(entity: projectile))
        EventSystem.playerAmmoUpdateEvent.post(event: PlayerAmmoUpdateEvent(weapon: weapon, ammo: weapon.getAmmo()))
        //        projectile.spawn(gameManager: gameManager)

        return true
    }

    func switchWeapon<T: Weapon>(to weapon: T.Type) {
        guard let weapon = availableWeapons.compactMap({ $0 as? T }).first else {
            return
        }

        activeWeapon = weapon
    }

    func getAmmo() -> [(Weapon, [Ammo])] {
        var ammoList = [(Weapon, [Ammo])]()
        for weapon in availableWeapons {
            ammoList.append((weapon, weapon.getAmmo()))
        }
        return ammoList
    }
}

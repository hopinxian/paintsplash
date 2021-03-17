//
//  WeaponSystemImpl.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//

class PaintWeaponsSystem: MultiWeaponSystem {
    var activeWeapon: PaintWeapon?
    var availableWeapons: [PaintWeapon]
    var carriedBy: Transformable?

    init(weapons: [PaintWeapon]) {
        self.activeWeapon = weapons[0]
        self.availableWeapons = weapons
    }
    
    func load(_ ammo: [PaintAmmo]) {
        guard let weapon = activeWeapon else {
            return
        }
        weapon.load(ammo)
        EventSystem.playerAmmoUpdateEvent.post(event: PlayerAmmoUpdateEvent(weapon: weapon, ammo: weapon.getAmmo()))
    }

    func load(to weapon: PaintWeapon, ammo: [PaintAmmo]) {
        guard availableWeapons.contains(where: { $0 === weapon }) else {
            return
        }

        weapon.load(ammo)
        EventSystem.playerAmmoUpdateEvent.post(event: PlayerAmmoUpdateEvent(weapon: weapon, ammo: weapon.getAmmo()))
    }

    func shoot() -> Bool {

        // Handle shooting here
        guard let weapon = activeWeapon,
              let projectile = weapon.shoot(),
              let carriedBy = carriedBy else {
            return false
        }

        projectile.move(to: carriedBy.transform.position)

        EventSystem.addEntityEvent.post(event: AddEntityEvent(entity: projectile))
        EventSystem.playerAmmoUpdateEvent.post(event: PlayerAmmoUpdateEvent(weapon: weapon, ammo: weapon.getAmmo()))
        //        projectile.spawn(gameManager: gameManager)

        return true
    }

    func switchWeapon(to weapon: PaintWeapon) {
        guard availableWeapons.contains(where: { $0 === weapon }) else {
            return
        }

        activeWeapon = weapon
    }

    func getAmmo() -> [(PaintWeapon, [PaintAmmo])] {
        var ammoList = [(PaintWeapon, [PaintAmmo])]()
        for weapon in availableWeapons {
            ammoList.append((weapon, weapon.getAmmo()))
        }
        return ammoList
    }
}

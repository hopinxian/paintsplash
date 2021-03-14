//
//  WeaponSystemImpl.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//

class PaintWeaponsSystem: MultiWeaponSystem {
    private let gameManager: GameManager

    var activeWeapon: PaintWeapon?
    var availableWeapons: [PaintWeapon]
    var carriedBy: Transformable?

    init(weapons: [PaintWeapon], gameManager: GameManager) {
        self.activeWeapon = weapons[0]
        self.availableWeapons = weapons
        self.gameManager = gameManager
    }
    
    func load(_ ammo: [PaintAmmo]) {
        print("system load")
        activeWeapon?.load(ammo)
    }

    func load(to weapon: PaintWeapon, ammo: [PaintAmmo]) {
        guard availableWeapons.contains(where: { $0 === weapon }) else {
            return
        }

        weapon.load(ammo)
    }

    func shoot() -> Bool {
//        print("Trying to Shoot")

        // Handle shooting here
        guard let projectile = activeWeapon?.shoot(),
              let carriedBy = carriedBy else {
            return false
        }

        projectile.move(to: carriedBy.transform.position)
        projectile.spawn(gameManager: gameManager)

        return true
    }

    func switchWeapon(to weapon: PaintWeapon) {
        guard availableWeapons.contains(where: { $0 === weapon }) else {
            return
        }

        activeWeapon = weapon
    }

}

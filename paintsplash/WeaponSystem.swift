//
//  WeaponSystem.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

protocol WeaponSystem {
    var activeWeapon: Weapon { get set }
    var availableWeapons: [Weapon] { get set }

    func load(_ projectiles: Projectile ...)
    func load(to weapon: Weapon, projectiles: Projectile ...)
    func shoot() -> Bool
    func switchWeapon(to weapon: Weapon)
}

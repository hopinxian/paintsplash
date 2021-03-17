//
//  WeaponSystem.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

protocol MultiWeaponSystem {
    var activeWeapon: Weapon? { get set }
    var availableWeapons: [Weapon] { get set }
    var carriedBy: Transformable? { get set }
    func load(_ ammo: [Ammo])
    func load<T: Weapon>(to weaponType: T.Type, ammo: [Ammo])
    func shoot() -> Bool
    func switchWeapon<T: Weapon>(to weapon: T.Type)
    func getAmmo() -> [(Weapon, [Ammo])]
}
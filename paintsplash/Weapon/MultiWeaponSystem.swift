//
//  WeaponSystem.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

protocol MultiWeaponSystem {
    associatedtype WeaponType: Weapon

    var activeWeapon: WeaponType? { get set }
    var availableWeapons: [WeaponType] { get set }
    var carriedBy: Transformable? { get set }
    func load(_ ammo: [WeaponType.AmmoType])
    func load(to weapon: WeaponType, ammo: [WeaponType.AmmoType])
    func shoot() -> Bool
    func switchWeapon(to weapon: WeaponType)
    func getAmmo() -> [(WeaponType, [WeaponType.AmmoType])]
}

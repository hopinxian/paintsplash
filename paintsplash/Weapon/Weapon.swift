//
//  Weapon.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

protocol Weapon {
//    var remainingAmmo: [Projectile] { get set }
//    var canShoot: Bool { get }
    associatedtype AmmoType: Ammo
    func load(_ ammo: [AmmoType])
    func shoot() -> Projectile?
    func canShoot() -> Bool
    func getAmmo() -> [AmmoType]
}

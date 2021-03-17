//
//  Weapon.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

protocol Weapon: AnyObject {
//    var remainingAmmo: [Projectile] { get set }
//    var canShoot: Bool { get }
    func load(_ ammo: [Ammo])
    func shoot() -> Projectile?
    func canShoot() -> Bool
    func getAmmo() -> [Ammo]
}

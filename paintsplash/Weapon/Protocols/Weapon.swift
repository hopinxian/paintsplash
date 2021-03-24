//
//  Weapon.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

protocol Weapon: AnyObject {
    var capacity: Int { get set }
    func load(_ ammo: [Ammo])
    func shoot(in direction: Vector2D) -> Projectile?
    func canShoot() -> Bool
    func getAmmo() -> [Ammo]
    func canLoad(_ ammo: [Ammo]) -> Bool
}
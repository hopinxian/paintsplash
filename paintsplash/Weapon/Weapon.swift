//
//  Weapon.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

protocol Weapon {
    var remainingAmmo: [Projectile] { get set }
    var canShoot: Bool { get }
    func load(_ projectiles: Projectile ...)
    func shoot() -> Projectile
}

//
//  Bucket.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//

class Bucket: PaintWeapon {
    private var ammoQueue = Queue<PaintAmmo>()

    private let maxCoolDown = 100.0
    private var currentCoolDown = 0.0

    override func load(_ ammo: [PaintAmmo]) {
        for item in ammo {
            ammoQueue.enqueue(item)
        }
    }

    override func shoot() -> Projectile? {
        guard let ammo = ammoQueue.dequeue(),
              canShoot() else {
            return nil
        }

        return PaintProjectile(color: ammo.color, radius: 50.0, velocity: Vector2D(3, 0))
    }

    override func canShoot() -> Bool {
        currentCoolDown == 0
    }
}

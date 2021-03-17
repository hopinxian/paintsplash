//
//  Bucket.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//

class Bucket: Weapon {

    private let maxCoolDown = 100.0
    private var currentCoolDown = 0.0

    private var ammoQueue = [PaintAmmo]()

    func load(_ ammos: [Ammo]) {
        for ammo in ammos {
            if let paintAmmo = ammo as? PaintAmmo {
                load(paintAmmo)
            }
        }
    }

    func load(_ ammo: PaintAmmo) {
        ammoQueue.append(ammo)
        mix()
    }

    /// Mixes the last two colors in the queue
    private func mix() {
        let size = ammoQueue.count
        guard size > 1 else {
            return
        }
        let colorA = ammoQueue[size - 1].color
        let colorB = ammoQueue[size - 2].color
        if let result = colorA.mix(with: [colorB]) {
            ammoQueue[size - 1].color = result
            ammoQueue[size - 2].color = result
        }
    }

    func shoot() -> Projectile? {
        guard !ammoQueue.isEmpty && canShoot() else {
            return nil
        }
        let ammo = ammoQueue.removeFirst()

        return PaintProjectile(color: ammo.color, radius: 25.0, velocity: Vector2D(3, 0))
    }

    func canShoot() -> Bool {
        currentCoolDown == 0
    }


    func getAmmo() -> [Ammo] {
        ammoQueue
    }
}

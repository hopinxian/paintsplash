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
        assert(checkRepresentation())
    }

    func load(_ ammo: PaintAmmo) {
        ammoQueue.append(ammo)
        mix()
        assert(checkRepresentation())
    }

    private func mix() {
        let size = ammoQueue.count
        guard size > 1 else {
            return
        }

        // mixes until no two adjacent units of color are mixable

        var i = size - 1
        while i != 0 {
            let colorA = ammoQueue[i].color
            let colorB = ammoQueue[i - 1].color
            if let result = colorA.mix(with: [colorB]),
               (result != colorA || result != colorB) {
                ammoQueue[i].color = result
                ammoQueue[i - 1].color = result
                i = min(i + 1, size - 1)
            } else {
                i -= 1
            }
        }
        assert(checkRepresentation())
    }

    func shoot() -> Projectile? {
        guard !ammoQueue.isEmpty && canShoot() else {
            return nil
        }
        let ammo = ammoQueue.removeFirst()

        assert(checkRepresentation())
        return PaintProjectile(color: ammo.color, radius: 25.0, velocity: Vector2D(3, 0))
    }

    func canShoot() -> Bool {
        currentCoolDown == 0
    }


    func getAmmo() -> [Ammo] {
        ammoQueue
    }

    /// Checks that no further mixing of paint within the weapon is possible
    private func checkRepresentation() -> Bool {
        guard ammoQueue.count > 1 else {
            return true
        }

        for i in 0..<ammoQueue.count - 1 {
            let colorA = ammoQueue[i].color
            let colorB = ammoQueue[i + 1].color
            let mix = colorA.mix(with: [colorB])
            if mix != nil && mix != colorA && mix != colorB {
                return false
            }
        }
        return true
    }
}

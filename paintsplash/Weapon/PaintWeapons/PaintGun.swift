//
//  PaintGun.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//
class PaintGun: Weapon {
    var capacity: Int = 4

    private let maxCoolDown = 100.0
    private var currentCoolDown = 0.0

    private var ammoStack = [PaintAmmo]()

    func load(_ ammos: [Ammo]) {
        for ammo in ammos {
            if let paintAmmo = ammo as? PaintAmmo {
                load(paintAmmo)
            }
        }
    }

    func load(_ ammo: PaintAmmo) {
        guard ammoStack.count < capacity else {
            return
        }

        ammoStack.append(ammo)
        mix()
    }

    /// Mixes the last two colors in the stack
    private func mix() {
        let size = ammoStack.count
        guard size > 1 else {
            return
        }
        let colorA = ammoStack[size - 1].color
        let colorB = ammoStack[size - 2].color
        if let result = colorA.mix(with: [colorB]) {
            ammoStack[size - 1].color = result
            ammoStack[size - 2].color = result
        }
    }

    func shoot(in direction: Vector2D) -> Projectile? {
        guard let ammo = ammoStack.popLast(), canShoot() else {
            return nil
        }
        return PaintProjectile(color: ammo.color, radius: 25.0, direction: direction)
    }

    func canShoot() -> Bool {
        currentCoolDown == 0
    }

    func getAmmo() -> [Ammo] {
        ammoStack
    }

    func canLoad(_ ammo: [Ammo]) -> Bool {
        ammoStack.count < capacity
    }
}

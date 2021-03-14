//
//  PaintGun.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//

class PaintGun: PaintWeapon {
    private var ammoStack = Stack<PaintAmmo>()

    private let maxCoolDown = 100.0
    private var currentCoolDown = 0.0

    override func load(_ ammo: [PaintAmmo]) {
        print("loaded")
        for item in ammo {
            ammoStack.push(item)
        }
        /*
         Paintgun needs to implement the specifics of the stack
         else it would be difficult to do the mixing within it
         */
    }

    override func shoot() -> Projectile? {
        guard let ammo = ammoStack.pop(),
              canShoot() else {
            return nil
        }

        return PaintProjectile(color: ammo.color, radius: 50.0, velocity: Vector2D(3, 0))
    }

    override func canShoot() -> Bool {
        currentCoolDown == 0
    }
}

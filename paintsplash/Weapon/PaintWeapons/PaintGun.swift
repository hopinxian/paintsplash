//
//  PaintGun.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//

class PaintGun: PaintWeapon {
//    private var ammoStack = Stack<PaintAmmo>()

    private let maxCoolDown = 100.0
    private var currentCoolDown = 0.0

    private var ammoStack = [PaintAmmo]()
    
    override func load(_ ammos: [PaintAmmo]) {
        for ammo in ammos {
            load(ammo)
        }
    }
    
    private func load(_ ammo: PaintAmmo) {
        ammoStack.append(ammo)
        mix()
    }
    
    private func mix() {
        let count = ammoStack.count
        
        // mixes two units every time
        for i in 1..<count {
            let firstColor = ammoStack[count - i].color
            let secondColor = ammoStack[count - i - 1].color
            if let result = firstColor.mix(with: [secondColor]) {
                ammoStack[count - i].color = result
                ammoStack[count - i - 1].color = result
            } else {
                break
            }
        }
    }
    
    override func shoot() -> Projectile? {
        guard let ammo = ammoStack.popLast(), canShoot() else {
            return nil
        }

        return PaintProjectile(color: ammo.color, radius: 25.0, velocity: Vector2D(3, 0))
    }
    
    override func canShoot() -> Bool {
        currentCoolDown == 0
    }

    override func getAmmo() -> [PaintAmmo] {
        ammoStack
    }
}

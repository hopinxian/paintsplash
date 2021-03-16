//
//  PaintGun.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//

class PaintGun: PaintWeapon {
    private let maxCoolDown = 100.0
    private var currentCoolDown = 0.0

    private var ammoStack = [PaintAmmo]()
    
    override func load(_ ammos: [PaintAmmo]) {
        for ammo in ammos {
            load(ammo)
        }
        assert(checkRepresentation())
    }
    
    func load(_ ammo: PaintAmmo) {
        ammoStack.append(ammo)
        mix()
        assert(checkRepresentation())
    }
    
    private func mix() {
        let size = ammoStack.count
        guard size > 1 else {
            return
        }
        
        // mixes until no two adjacent units of color are mixable
        
        var i = size - 1
        while i != 0 {
            let colorA = ammoStack[i].color
            let colorB = ammoStack[i - 1].color
            if let result = colorA.mix(with: [colorB]),
               (result != colorA || result != colorB) {
                ammoStack[i].color = result
                ammoStack[i - 1].color = result
                i = min(i + 1, size - 1)
            } else {
                i -= 1
            }
        }
        
        assert(checkRepresentation())
    }
    
    override func shoot() -> Projectile? {
        guard let ammo = ammoStack.popLast(), canShoot() else {
            return nil
        }
        assert(checkRepresentation())
        return PaintProjectile(color: ammo.color, radius: 50.0, velocity: Vector2D(3, 0))
    }
    
    override func canShoot() -> Bool {
        currentCoolDown == 0
    }
    
    /// Checks that no further mixing of paint within the weapon is possible
    private func checkRepresentation() -> Bool {
        guard ammoStack.count > 1 else {
            return true
        }
        
        for i in 0..<ammoStack.count - 1 {
            let colorA = ammoStack[i].color
            let colorB = ammoStack[i + 1].color
            let mix = colorA.mix(with: [colorB])
            if mix != nil && mix != colorA && mix != colorB {
                return false
            }
        }
        return true
    }
}

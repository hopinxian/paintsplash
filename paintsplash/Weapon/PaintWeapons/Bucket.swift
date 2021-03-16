//
//  Bucket.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//

class Bucket: PaintWeapon {

    private let maxCoolDown = 100.0
    private var currentCoolDown = 0.0
    
    private var ammoQueue = [PaintAmmo]()
    
    override func load(_ ammos: [PaintAmmo]) {
        for ammo in ammos {
            load(ammo)
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
        
        // mixes two units every time
        for i in 1..<size {
            let firstColor = ammoQueue[size - i].color
            let secondColor = ammoQueue[size - i - 1].color
            if let result = firstColor.mix(with: [secondColor]) {
                ammoQueue[size - i].color = result
                ammoQueue[size - i - 1].color = result
            } else {
                break
            }
        }
        assert(checkRepresentation())
    }

    override func shoot() -> Projectile? {
        guard !ammoQueue.isEmpty && canShoot() else {
            return nil
        }
        let ammo = ammoQueue.removeFirst()
        assert(checkRepresentation())
        return PaintProjectile(color: ammo.color, radius: 50.0, velocity: Vector2D(3, 0))
    }
    
    override func canShoot() -> Bool {
        currentCoolDown == 0
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
            if mix != nil && mix != colorA {
                return false
            }
        }
        return true
    }
}

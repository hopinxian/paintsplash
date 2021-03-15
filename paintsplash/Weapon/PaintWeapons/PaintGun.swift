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

//    override func load(_ ammo: [PaintAmmo]) {
//        print("loaded")
//        for item in ammo {
//            ammoStack.push(item)
//        }
//        /*
//         Paintgun needs to implement the specifics of the stack
//         else it would be difficult to do the mixing within it
//         */
//    }
//
//    override func shoot() -> Projectile? {
//        guard let ammo = ammoStack.pop(),
//              canShoot() else {
//            return nil
//        }
//
//        return PaintProjectile(color: ammo.color, radius: 50.0, velocity: Vector2D(3, 0))
//    }

    private var ammoStack = [PaintAmmo]()
    
    override func load(_ ammos: [PaintAmmo]) {
        for ammo in ammoStack {
            print("Stack Content: " + ammo.color.rawValue)
        }
        for ammo in ammos {
            print("Load " + ammo.color.rawValue)
        }
        for ammo in ammos {
            load(ammo)
        }
        for ammo in ammoStack {
            print("Stack Content: " + ammo.color.rawValue)
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
        print("Shoot from stack " + ammo.color.rawValue + " ammo")
        return PaintProjectile(color: ammo.color, radius: 50.0, velocity: Vector2D(3, 0))
    }
    
    override func canShoot() -> Bool {
        currentCoolDown == 0
    }
}

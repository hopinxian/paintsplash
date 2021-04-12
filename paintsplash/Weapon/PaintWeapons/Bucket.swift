//
//  Bucket.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//

class Bucket: WeaponComponent {
    private let maxCoolDown = 100.0
    private var currentCoolDown = 0.0

    private var ammoQueue = [PaintAmmo]()

    init() {
        super.init(capacity: 4)
    }

    override func load(_ ammos: [Ammo]) {
        for ammo in ammos {
            if let paintAmmo = ammo as? PaintAmmo {
                load(paintAmmo)
            }
        }
    }

    func load(_ ammo: PaintAmmo) {
        guard ammoQueue.count < capacity else {
            return
        }

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

    override func shoot(from position: Vector2D, in direction: Vector2D) -> Projectile? {
        guard !ammoQueue.isEmpty && canShoot() else {
            return nil
        }
        let ammo = ammoQueue.removeFirst()
        let spawnPosition = position + (direction.unitVector * 100)

        return PaintProjectile(color: ammo.color, position: spawnPosition, radius: 75, direction: Vector2D.zero)
    }

    override func canShoot() -> Bool {
        currentCoolDown == 0 && !ammoQueue.isEmpty
    }

    override func getAmmo() -> [Ammo] {
        ammoQueue
    }

    override func canLoad(_ ammo: [Ammo]) -> Bool {
        ammoQueue.count < capacity
    }

    override func getShootSFX() -> SoundEffect? {
        SoundEffect.paintBucketAttack
    }
}

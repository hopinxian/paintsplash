//
//  Bomb.swift
//  paintsplash
//
//  Created by Farrell Nah on 13/4/21.
//

class Bomb: WeaponComponent {
    var ammoSource: Weapon?

    init() {
        super.init(capacity: 1)
    }

    convenience init(ammoSource: Weapon) {
        self.init()
        self.ammoSource = ammoSource
    }

    override func shoot(from position: Vector2D, in direction: Vector2D) -> Projectile? {
        guard canShoot() else {
            return nil
        }

        while ammoSource?.canShoot() == true {
            _ = ammoSource?.shoot(from: Vector2D.zero, in: Vector2D.zero)
        }

        return PaintBucketSplash(color: .white, position: Vector2D.zero, radius: 10_000, direction: Vector2D.zero)
    }

    override func canShoot() -> Bool {
        ammoSource?.canShoot() ?? false
    }

    override func getShootSFX() -> SoundEffect? {
        SoundEffect.paintGunAttack
    }
}

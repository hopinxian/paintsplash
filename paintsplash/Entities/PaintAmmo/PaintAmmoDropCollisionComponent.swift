//
//  PaintAmmoDropCollisionComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 18/4/21.
//

class PaintAmmoDropCollisionComponent: CollisionComponent {
    weak var ammoDrop: PaintAmmoDrop?

    override func onCollide(with: Collidable) {
        guard let ammoDrop = ammoDrop,
              let ammo = ammoDrop.getAmmoObject() else {
            return
        }

        if with.collisionComponent.tags.contains(.player) {
            switch with {
            case let player as Player:
                if player.multiWeaponComponent.canLoad([ammo]) {
                    ammoDrop.destroy()
                }
            default:
                fatalError("Player does not conform to Player")
            }
        }

        if with.collisionComponent.tags.contains(.enemy) {
            guard let enemy = with as? Enemy,
                  enemy.color.mix(with: [ammoDrop.color]) != nil else {
                return
            }
            ammoDrop.destroy()
        }
    }
}

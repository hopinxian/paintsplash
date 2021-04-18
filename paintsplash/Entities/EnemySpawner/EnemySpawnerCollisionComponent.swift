//
//  EnemySpawnerCollisionComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 18/4/21.
//

class EnemySpawnerCollisionComponent: CollisionComponent {
    weak var spawner: EnemySpawner?

    override func onCollide(with: Collidable) {

        guard let spawner = spawner else {
            return
        }

        if with.collisionComponent.tags.contains(.playerProjectile) {
            switch with {
            case let projectile as PaintProjectile:
                if projectile.color.contains(color: spawner.color) ||
                    projectile.color == PaintColor.white {
                    spawner.healthComponent.takeDamage(amount: 1)
                }
            case let splash as PaintBucketSplash:
                if splash.color.contains(color: spawner.color) ||
                    splash.color == PaintColor.white {
                    spawner.healthComponent.takeDamage(amount: 1)
                }
            default:
                fatalError("Projectile not conforming to projectile protocol")
            }
        }
    }
}

//
//  PaintProjectileCollisionComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 18/4/21.
//

class PaintProjectileCollisionComponent: CollisionComponent {
    weak var projectile: PaintProjectile?

    override func onCollide(with: Collidable) {
        guard let projectile = projectile else {
            return
        }

        var destroy = false
        switch with {
        case let enemy as Enemy:
            if projectile.color.contains(color: enemy.color) {
                destroy = true
            }
        case let enemy as EnemySpawner:
            if projectile.color.contains(color: enemy.color) {
                destroy = true
            }
        case _ as Canvas:
            destroy = true
        default:
            destroy = false
        }

        if destroy {
            projectile.destroy()
        }
    }
}

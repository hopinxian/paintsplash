//
//  EnemyCollisionComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 18/4/21.
//

class EnemyCollisionComponent: CollisionComponent {
    weak var enemy: Enemy?

    override func onCollide(with: Collidable) {
        guard let enemy = enemy else {
            return
        }

        if with.collisionComponent.tags.contains(.playerProjectile) {
            onCollideWithPlayerProjectile(with: with)
        }

        if with.collisionComponent.tags.contains(.enemy) {
            onCollideWithAnotherEnemy(with: with)
        }

        if with.collisionComponent.tags.contains(.ammoDrop) {
            onCollideWithAmmoDrop(with: with)
        }

        if with.collisionComponent.tags.contains(.player) {
            enemy.healthComponent.takeDamage(amount: 1)
        }
    }

    private func onCollideWithAmmoDrop(with: Collidable) {
        guard let enemy = enemy,
              let ammoDrop = with as? PaintAmmoDrop,
              let newColor = ammoDrop.color.mix(with: [enemy.color]) else {
            return
        }
        enemy.color = newColor
    }

    private func onCollideWithAnotherEnemy(with: Collidable) {
        guard let enemy = enemy,
              let otherEnemy = with as? Enemy,
              let newColor = enemy.color.mix(with: [otherEnemy.color]) else {
            return
        }

        // Set collision component to default to avoid repeated, unnecessary collisions
        enemy.collisionComponent = CollisionComponent(colliderShape: enemy.collisionComponent.colliderShape,
                                                      tags: [])
        enemy.destroy()
        otherEnemy.collisionComponent = CollisionComponent(colliderShape: enemy.collisionComponent.colliderShape,
                                                           tags: [])
        otherEnemy.destroy()

        // Spawn a larger enemy with the mixed color
        let midPoint = (enemy.transformComponent.worldPosition + otherEnemy.transformComponent.worldPosition) / 2
        let biggerEnemy = Enemy(initialPosition: midPoint,
                                color: newColor,
                                health: Constants.ENEMY_BIG_HEALTH,
                                size: Constants.ENEMY_BIG_SIZE,
                                radius: Constants.ENEMY_BIG_RADIUS)
        biggerEnemy.spawn()
        biggerEnemy.stateComponent.setState(EnemyState.Idle(enemy: biggerEnemy))
    }

    private func onCollideWithPlayerProjectile(with: Collidable) {
        guard let enemy = enemy else {
            return
        }

        switch with {
        case let projectile as PaintProjectile:
            if projectile.color.contains(color: enemy.color) ||
                projectile.color == PaintColor.white {
                enemy.healthComponent.takeDamage(amount: 1)
            }
        case let splash as PaintBucketSplash:
            if splash.color.contains(color: enemy.color) ||
                splash.color == PaintColor.white {
                enemy.healthComponent.takeDamage(amount: 1)
            }
        default:
            fatalError("Projectile not conforming to projectile protocol")
        }
    }
}

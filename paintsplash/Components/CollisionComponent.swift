//
//  CollisionComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class CollisionComponent: Component {
    var colliderShape: ColliderShape
    var tags: Tags

    init(colliderShape: ColliderShape, tags: [Tag]) {
        self.colliderShape = colliderShape
        self.tags = Tags(Set(tags))
    }

    func onCollide(with: Collidable) {
        // do nothing by default
    }
}

class PlayerCollisionComponent: CollisionComponent {
    weak var player: Player?

    override func onCollide(with: Collidable) {
        if with.collisionComponent.tags.contains(.ammoDrop) {
            onCollideWithAmmoDrop(with: with)
        }

        if with.collisionComponent.tags.contains(.enemy) {
            onCollideWithEnemy(with: with)
        }
    }

    private func onCollideWithAmmoDrop(with: Collidable) {
        switch with {
        case let ammoDrop as PaintAmmoDrop:
            loadAmmoDrop(ammoDrop)
        default:
            fatalError("Ammo Drop not conforming to AmmoDrop protocol")
        }
    }

    private func loadAmmoDrop(_ drop: PaintAmmoDrop) {
        guard let player = player else {
            return
        }

        let ammo = drop.getAmmoObject()
        if player.multiWeaponComponent.canLoad([ammo]) {
            player.multiWeaponComponent.load([ammo])
            let event = PlayerAmmoUpdateEvent(
                weaponType: type(of: player.multiWeaponComponent.activeWeapon),
                ammo: player.multiWeaponComponent.activeWeapon.getAmmo(),
                playerId: player.id
            )

            EventSystem.playerActionEvent.playerAmmoUpdateEvent.post(
                event: event
            )
        }
    }

    private func onCollideWithEnemy(with: Collidable) {
        // TODO: ensure that enemy collide with enemy spawner/other objects is ok
        switch with {
        case _ as Enemy:
            player?.healthComponent.takeDamage(amount: 1)
        default:
            fatalError("Enemy does not conform to any enemy type")
        }
    }
}

class EnemySpawnerCollisionComponent: CollisionComponent {
    weak var spawner: EnemySpawner?

    override func onCollide(with: Collidable) {

        guard let spawner = spawner else {
            return
        }

        if with.collisionComponent.tags.contains(.playerProjectile) {
            switch with {
            case let projectile as PaintProjectile:
                // send event here
                if projectile.color.contains(color: spawner.color) || projectile.color == PaintColor.white {
                    spawner.healthComponent.takeDamage(amount: 1)
                }
            default:
                fatalError("Projectile not conforming to projectile protocol")
            }
        }
    }
}

class EnemyCollisionComponent: CollisionComponent {
    weak var enemy: Enemy?

    override func onCollide(with: Collidable) {
        guard let enemy = enemy else {
            return
        }

        if with.collisionComponent.tags.contains(.playerProjectile) {
            onCollideWithPlayerProjectile(with: with)
        }

        if with.collisionComponent.tags.contains(.player) {
            enemy.healthComponent.takeDamage(amount: 1)
            print("take damage")
        }
    }

    private func onCollideWithPlayerProjectile(with: Collidable) {
        guard let enemy = enemy else {
            return
        }

        switch with {
        case let projectile as PaintProjectile:
            if projectile.color.contains(color: enemy.color) || projectile.color == PaintColor.white {
                enemy.healthComponent.takeDamage(amount: 1)
            }
        default:
            fatalError("Projectile not conforming to projectile protocol")
        }
    }
}

class CanvasCollisionComponent: CollisionComponent {

    weak var canvas: Canvas?

    override func onCollide(with: Collidable) {

        guard let canvas = canvas else {
            return
        }

        switch with {
        case let ammo as PaintProjectile:
            let color = ammo.color
            canvas.colors.insert(color)

            let blob = PaintBlob(color: color, canvas: canvas)
            blob.spawn()
            canvas.paintedColors.insert(blob)

            // post notification to alert system about colours on the current canvas
            let canvasHitEvent = CanvasHitEvent(canvas: canvas)
            EventSystem.canvasEvent.canvasHitEvent.post(event: canvasHitEvent)
        default:
            break
        }
    }
}

class PaintAmmoDropCollisionComponent: CollisionComponent {

    weak var ammoDrop: PaintAmmoDrop?

    override func onCollide(with: Collidable) {
        guard let ammoDrop = ammoDrop else {
            return
        }

        if with.collisionComponent.tags.contains(.player) {
            switch with {
            case let player as Player:
                if player.multiWeaponComponent.canLoad([ammoDrop.getAmmoObject()]) {
                    EventSystem.entityChangeEvents.removeEntityEvent.post(
                        event: RemoveEntityEvent(entity: ammoDrop)
                    )
                }
            default:
                fatalError("Player does not conform to Player")
            }
        }
    }
}

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

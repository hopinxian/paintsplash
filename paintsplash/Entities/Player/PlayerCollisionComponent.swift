//
//  PlayerCollisionComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 18/4/21.
//

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
        case let ammoDrop as AmmoDrop:
            loadAmmoDrop(ammoDrop)
        default:
            fatalError("Ammo Drop not conforming to AmmoDrop protocol")
        }
    }

    private func loadAmmoDrop(_ drop: AmmoDrop) {
        guard let player = player,
              let ammo = drop.getAmmoObject() else {
            return
        }

        if player.multiWeaponComponent.canLoad([ammo]) {
            player.multiWeaponComponent.load([ammo])
            let ammoUpdateEvent = PlayerAmmoUpdateEvent(
                weaponType: type(of: player.multiWeaponComponent.activeWeapon),
                ammo: player.multiWeaponComponent.activeWeapon.getAmmo(),
                playerId: player.id
            )

            EventSystem.playerActionEvent.playerAmmoUpdateEvent.post(
                event: ammoUpdateEvent
            )

            let sfxEvent = PlaySoundEffectEvent(effect: SoundEffect.ammoPickup, playerId: player.id)
            EventSystem.audioEvent.playSoundEffectEvent.post(event: sfxEvent)
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

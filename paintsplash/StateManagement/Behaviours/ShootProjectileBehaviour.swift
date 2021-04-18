//
//  ShootProjectileBehaviour.swift
//  paintsplash
//
//  Created by Farrell Nah on 24/3/21.
//

/// Shoots a projectile in the provided direction.
struct ShootProjectileBehaviour: StateBehaviour {
    var shootDirection: Vector2D

    func run(statefulEntity: StatefulEntity, gameInfo: GameInfo) {
        guard let player = statefulEntity as? Player else {
            return
        }

        _ = player.multiWeaponComponent.shoot(from: player.transformComponent.worldPosition, in: shootDirection)

        if let sfx = player.multiWeaponComponent.getShootSFX() {
            let soundEvent = PlaySoundEffectEvent(
                effect: sfx,
                playerId: player.id
            )
            EventSystem.audioEvent.playSoundEffectEvent.post(event: soundEvent)
        }

        let ammoEvent = PlayerAmmoUpdateEvent(
            weaponType: type(of: player.multiWeaponComponent.activeWeapon),
            ammo: player.multiWeaponComponent.activeWeapon.getAmmo(),
            playerId: player.id
        )
        EventSystem.playerActionEvent.playerAmmoUpdateEvent.post(event: ammoEvent)
    }
}

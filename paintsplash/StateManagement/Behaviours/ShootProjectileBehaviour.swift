//
//  ShootProjectileBehaviour.swift
//  paintsplash
//
//  Created by Farrell Nah on 24/3/21.
//

class ShootProjectileBehaviour: StateBehaviour {

    var shootDirection: Vector2D

    init(shootDirection: Vector2D) {
        self.shootDirection = shootDirection
    }

    func updateAI(aiEntity: StatefulEntity, aiGameInfo: GameInfo) {
        guard let player = aiEntity as? Player else {
            return
        }

        _ = player.multiWeaponComponent.shoot(in: shootDirection)

        EventSystem.audioEvent.playSoundEffectEvent.post(event: PlaySoundEffectEvent(effect: SoundEffect.attack))

        EventSystem.playerActionEvent.playerAmmoUpdateEvent.post(
            event: PlayerAmmoUpdateEvent(
                weapon: player.multiWeaponComponent.activeWeapon,
                ammo: player.multiWeaponComponent.activeWeapon.getAmmo()
            )
        )
    }
}

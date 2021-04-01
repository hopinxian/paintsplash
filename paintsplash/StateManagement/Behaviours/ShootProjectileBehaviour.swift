//
//  ShootProjectileBehaviour.swift
//  paintsplash
//
//  Created by Farrell Nah on 24/3/21.
//

class ShootProjectileBehaviour: StateBehaviour {
    func updateAI(aiEntity: StatefulEntity, aiGameInfo: GameInfo) {
        guard let player = aiEntity as? Player else {
            return
        }

        _ = player.multiWeaponComponent.shoot(in: player.lastDirection)

        EventSystem.audioEvent.playSoundEffectEvent.post(event: PlaySoundEffectEvent(effect: SoundEffect.attack))

        EventSystem.playerActionEvent.playerAmmoUpdateEvent.post(
            event: PlayerAmmoUpdateEvent(
                weapon: player.multiWeaponComponent.activeWeapon,
                ammo: player.multiWeaponComponent.activeWeapon.getAmmo()
            )
        )
    }
}

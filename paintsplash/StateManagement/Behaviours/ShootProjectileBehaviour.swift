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

        _ = player.multiWeaponComponent.shoot(from: player.transformComponent.worldPosition, in: shootDirection)

        let soundEvent = PlaySoundEffectEvent(
            effect: SoundEffect.attack,
            playerId: player.id
        )
        EventSystem.audioEvent.playSoundEffectEvent.post(event: soundEvent)

        let ammoEvent = PlayerAmmoUpdateEvent(
            weaponType: type(of: player.multiWeaponComponent.activeWeapon),
            ammo: player.multiWeaponComponent.activeWeapon.getAmmo(),
            playerId: player.id
        )
        EventSystem.playerActionEvent.playerAmmoUpdateEvent.post(event: ammoEvent)
    }
}

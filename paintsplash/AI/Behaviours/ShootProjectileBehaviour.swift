//
//  ShootProjectileBehaviour.swift
//  paintsplash
//
//  Created by Farrell Nah on 24/3/21.
//

struct ShootProjectileBehaviour: AIBehaviour {
    func updateAI(aiEntity: AIEntity, aiGameInfo: AIGameInfo) {
        guard let player = aiEntity as? Player else {
            return
        }

        let _ = player.paintWeaponsSystem.shoot(in: player.lastDirection)

        EventSystem.audioEvent.playSoundEffectEvent.post(event: PlaySoundEffectEvent(effect: SoundEffect.attack))
    }
}

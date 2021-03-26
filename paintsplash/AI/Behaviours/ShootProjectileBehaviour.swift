//
//  ShootProjectileBehaviour.swift
//  paintsplash
//
//  Created by Farrell Nah on 24/3/21.
//

class ShootProjectileBehaviour: AIBehaviour {
    private var completed = false

    func updateAI(aiEntity: AIEntity, aiGameInfo: AIGameInfo) {
        guard !completed,
              let player = aiEntity as? Player else {
            return
        }

        _ = player.paintWeaponsSystem.shoot(in: player.lastDirection)

        EventSystem.audioEvent.playSoundEffectEvent.post(event: PlaySoundEffectEvent(effect: SoundEffect.attack))

        completed = true
    }
}

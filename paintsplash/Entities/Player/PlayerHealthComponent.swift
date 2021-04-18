//
//  PlayerHealthComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 18/4/21.
//

class PlayerHealthComponent: HealthComponent {
    weak var player: Player?

    override func heal(amount: Int) {
        super.heal(amount: amount)

        guard let id = player?.id else {
            return
        }

        let event = PlayerHealthUpdateEvent(
            newHealth: currentHealth,
            playerId: id
        )

        EventSystem.playerActionEvent.playerHealthUpdateEvent.post(event: event)
    }

    override func takeDamage(amount: Int) {
        super.takeDamage(amount: amount)

        guard let id = player?.id else {
            return
        }

        let event = PlayerHealthUpdateEvent(
            newHealth: currentHealth,
            playerId: id
        )

        EventSystem.playerActionEvent.playerHealthUpdateEvent.post(event: event)

        if currentHealth <= 0 {
            player?.stateComponent.setState(PlayerState.Die(player: player))
            EventSystem.audioEvent.playSoundEffectEvent.post(
                event: PlaySoundEffectEvent(effect: .playerDie, playerId: id))
        } else {
            EventSystem.audioEvent.playSoundEffectEvent.post(
                event: PlaySoundEffectEvent(effect: .playerHit, playerId: id))
        }
    }
}

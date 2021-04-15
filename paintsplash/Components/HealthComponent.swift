//
//  HealthComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class HealthComponent: Component {
    var currentHealth: Int {
        didSet {
            if currentHealth > maxHealth {
                currentHealth = maxHealth
            }

            if currentHealth < 0 {
                currentHealth = 0
            }
        }
    }

    var maxHealth: Int

    init(currentHealth: Int, maxHealth: Int) {
        self.currentHealth = currentHealth
        self.maxHealth = maxHealth
    }

    func heal(amount: Int) {
        currentHealth += amount
    }

    func takeDamage(amount: Int) {
        currentHealth -= amount
    }
}

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
            player?.stateComponent.currentState = PlayerState.Die(player: player)
            EventSystem.audioEvent.playSoundEffectEvent.post(
                event: PlaySoundEffectEvent(effect: .playerDie, playerId: id))
        } else {
            EventSystem.audioEvent.playSoundEffectEvent.post(
                event: PlaySoundEffectEvent(effect: .playerHit, playerId: id))
        }
    }
}

class EnemyHealthComponent: HealthComponent {

    weak var enemy: Enemy?

    override func takeDamage(amount: Int) {
        super.takeDamage(amount: amount)

        guard let enemy = enemy else {
            return
        }

        if enemy.healthComponent.currentHealth <= 0 {
            die()
            return
        }

        enemy.animationComponent.animate(
            animation: SlimeAnimations.slimeHit,
            interupt: true
        )
    }

    private func die() {
        guard let enemy = enemy else {
            return
        }

        enemy.moveableComponent.speed = 0
        enemy.collisionComponent.active = false
        enemy.stateComponent.currentState = EnemyState.Die(enemy: enemy)

        EventSystem.scoreEvent.post(event: ScoreEvent(value: Points.enemyKill))
    }
}

class EnemySpawnerHealthComponent: HealthComponent {

    weak var spawner: EnemySpawner?

    override func takeDamage(amount: Int) {
        super.takeDamage(amount: amount)

        if currentHealth <= 0 {
            die()
        }
    }

    private func die() {
        guard let spawner = spawner else {
            return
        }

        let event = RemoveEntityEvent(entity: spawner)
        EventSystem.entityChangeEvents.removeEntityEvent.post(event: event)
    }
}

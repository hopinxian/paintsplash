//
//  EnemyHealthComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 18/4/21.
//

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
        enemy.stateComponent.setState(EnemyState.Die(enemy: enemy))

        EventSystem.scoreEvent.post(event: ScoreEvent(value: Points.ENEMY_KILL))
    }
}

//
//  EnemySpawnerHealthComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 18/4/21.
//

class EnemySpawnerHealthComponent: HealthComponent {

    weak var spawner: EnemySpawner?

    override func takeDamage(amount: Int) {
        super.takeDamage(amount: amount)

        if currentHealth <= 0 {
            die()
            return
        }

        guard let spawner = spawner else {
            return
        }
        spawner.stateComponent.setState(EnemySpawnerState.Hit(spawner: spawner))
    }

    private func die() {
        guard let spawner = spawner else {
            return
        }

        EventSystem.scoreEvent.post(event: ScoreEvent(value: Points.ENEMY_SPAWNER_KILL))
        spawner.stateComponent.setState(EnemySpawnerState.Die(spawner: spawner))
    }
}

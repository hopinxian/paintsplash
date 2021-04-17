//
//  EnemySpawnerState+Hit.swift
//  paintsplash
//
//  Created by Farrell Nah on 17/4/21.
//

extension EnemySpawnerState {
    class Hit: EnemySpawnerState {
        override func onEnterState() {
            playSoundEffect()
            playAnimation()
        }

        private func playSoundEffect() {
            EventSystem.audioEvent.playSoundEffectEvent.post(
                event: PlaySoundEffectEvent(effect: SoundEffect.enemySpawn)
            )
        }

        private func playAnimation() {
            spawner.animationComponent.animate(
                animation: SpawnerAnimations.spawnerHit,
                interupt: true,
                callBack: { [weak self] in
                    self?.onHitOver()
                }
            )
        }

        private func onHitOver() {
            if spawner.healthComponent.currentHealth <= 0 {
                spawner.stateComponent.currentState = Die(spawner: spawner)
                return
            }

            spawner.stateComponent.currentState = Idle(
                spawner: spawner,
                idleTime: Constants.ENEMY_SPAWNER_INTERVAL
            )
        }
    }
}

//
//  EnemyState+ChasingLeft.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension EnemyState {
    class ChasingLeft: EnemyState {
        override func onEnterState() {
            EventSystem.audioEvent.playSoundEffectEvent.post(
                event: PlaySoundEffectEvent(effect: SoundEffect.enemyStep)
            )

            enemy.animationComponent.animate(animation: SlimeAnimations.slimeMoveLeftGray, interupt: true)

            enemy.lastDirection = enemy.moveableComponent.direction
        }

        override func getStateTransition() -> State? {
            if enemy.moveableComponent.direction.x > 0 {
                return ChasingRight(enemy: enemy)
            }

            return nil
        }

        override func getBehaviour() -> StateBehaviour {
            ChasePlayerBehaviour()
        }
    }
}

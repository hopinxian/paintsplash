//
//  EnemyState+ChasingLeft.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension EnemyState {
    class ChasingLeft: EnemyState {
        override func onEnterState() {
            enemy.animationComponent.animate(
                animation: SlimeAnimations.slimeMoveLeft,
                interupt: true
            )

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

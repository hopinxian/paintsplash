//
//  EnemyState+ChasingRight.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension EnemyState {
    class ChasingRight: EnemyState {
        override func onEnterState() {
            enemy.animationComponent.animate(animation: SlimeAnimations.slimeMoveRightGray, interupt: true)

            enemy.lastDirection = enemy.moveableComponent.direction
        }

        override func getStateTransition() -> State? {
            if enemy.moveableComponent.direction.x <= 0 {
                return ChasingLeft(enemy: enemy)
            }

            return nil
        }

        override func getBehaviour() -> StateBehaviour {
            ChasePlayerBehaviour()
        }
    }
}

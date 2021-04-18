//
//  EnemyState+Chasing.swift
//  paintsplash
//
//  Created by Farrell Nah on 18/4/21.
//

extension EnemyState {
    class Chasing: EnemyState {
        var moveAnimation: String
        var direction: Vector2D

        override init(enemy: Enemy) {
            self.moveAnimation = SlimeAnimations.slimeMoveLeft
            self.direction = Vector2D.left
            super.init(enemy: enemy)
        }

        override func onEnterState() {
            enemy.animationComponent.animate(
                animation: moveAnimation,
                interupt: true
            )

            enemy.lastDirection = enemy.moveableComponent.direction
        }

        override func getStateTransition() -> State? {
            if Vector2D.dot(enemy.moveableComponent.direction, direction) < 0 {
                return getOppositeState()
            }

            return nil
        }

        override func getBehaviour() -> StateBehaviour {
            ChasePlayerBehaviour()
        }

        func getOppositeState() -> EnemyState? {
            nil
        }
    }
}

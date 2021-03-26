//
//  EnemyState+Idle.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension EnemyState {
    class Idle: EnemyState {
        override func onEnterState() {
            enemy.animationComponent.animate(animation: SlimeAnimations.slimeIdleGray, interupt: true)
        }

        override func getStateTransition() -> State? {
            ChasingLeft(enemy: enemy)
        }
    }
}

//
//  EnemyState+Idle.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//
import Foundation

extension EnemyState {
    class Idle: EnemyState {
        let randomMoveLeftTime: Double
        private let startTime: Date

        override init(enemy: Enemy) {
            self.randomMoveLeftTime = Double.random(in: 1.0..<4.0)
            self.startTime = Date()
            super.init(enemy: enemy)
        }

        override func onEnterState() {
            let animationToPlay = enemy.lastDirection.x < 0 ?
                SlimeAnimations.slimeIdleLeft : SlimeAnimations.slimeIdleRight

            enemy.animationComponent.animate(
                animation: animationToPlay,
                interupt: true
            )

            enemy.moveableComponent.direction = .zero
        }

        override func getStateTransition() -> State? {
            let timeSinceStart = Date().timeIntervalSince(startTime)
            if timeSinceStart <= randomMoveLeftTime {
                return nil
            }

            let randomNum = Int.random(in: -1...1)
            switch randomNum {
            case 0:
                return nil
            case 1:
                return RandomMovementRight(enemy: enemy)
            case -1:
                return RandomMovementLeft(enemy: enemy)
            default:
                return nil
            }
        }
    }
}

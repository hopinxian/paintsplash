//
//  EnemyState+RandomMovementRight.swift
//  paintsplash
//
//  Created by Cynthia Lee on 15/4/21.
//

import Foundation

extension EnemyState {
    class RandomMovementRight: EnemyState {
        let randomMoveRightTime: Double
        private let startTime: Date
        private let direction: Vector2D

        init(enemy: Enemy,
             direction: Vector2D = Vector2D.random(xRange: 0.9 ..< 1.0, yRange: -1.0..<1.0).unitVector,
             duration: Double = Double.random(in: 1.0..<3.0)) {
            self.randomMoveRightTime = duration
            self.startTime = Date()
            self.direction = direction
            super.init(enemy: enemy)
        }

        override func onEnterState() {
            enemy.moveableComponent.direction = direction

            enemy.animationComponent.animate(animation: SlimeAnimations.slimeMoveRight, interupt: true)

            enemy.lastDirection = enemy.moveableComponent.direction
        }

        override func getStateTransition() -> State? {
            // Check position to ensure that slime does not go out of bounds
            // Change direction if necessary
            if enemy.transformComponent.maxX >= Constants.PLAYER_MOVEMENT_BOUNDS.maxX {
                return RandomMovementLeft(enemy: enemy)
            }

            if enemy.transformComponent.maxY >= Constants.PLAYER_MOVEMENT_BOUNDS.maxY {
                return RandomMovementRight(enemy: enemy, direction: Vector2D(direction.x, -1.0))
            }

            if enemy.transformComponent.minY <= Constants.PLAYER_MOVEMENT_BOUNDS.minY {
                return RandomMovementRight(enemy: enemy, direction: Vector2D(direction.x, 1.0))
            }

            // Check if full duration has elapsed
            let timeSinceStart = Date().timeIntervalSince(startTime)
            if timeSinceStart <= randomMoveRightTime {
                return nil
            }

            // Randomly decide next state
            let randomNum = Int.random(in: -1...1)
            switch randomNum {
            case 0:
                return Idle(enemy: enemy)
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

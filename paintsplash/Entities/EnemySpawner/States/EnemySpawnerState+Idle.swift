//
//  EnemySpawnerState+Idle.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//
import Foundation

extension EnemySpawnerState {
    class Idle: EnemySpawnerState {
        let idleTime: Double
        private let startTime: Date

        init(spawner: EnemySpawner, idleTime: Double) {
            self.idleTime = idleTime
            self.startTime = Date()
            super.init(spawner: spawner)
        }

        override func onEnterState() {
            spawner.animationComponent.animate(
                animation: SpawnerAnimations.spawnerIdle,
                interupt: true
            )
        }

        override func getStateTransition() -> State? {
            let timeSinceStart = Date().timeIntervalSince(startTime)
            if timeSinceStart > idleTime {
                return Spawning(spawner: spawner)
            }
            return nil
        }
    }
}

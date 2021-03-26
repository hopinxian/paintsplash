//
//  CanvasSpawnerState+Idle.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//
import Foundation

extension CanvasSpawnerState {
    class Idle: CanvasSpawnerState {
        let idleTime: Double
        private let startTime: Date

        init(spawner: CanvasSpawner, idleTime: Double) {
            self.idleTime = idleTime
            self.startTime = Date()
            super.init(spawner: spawner)
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

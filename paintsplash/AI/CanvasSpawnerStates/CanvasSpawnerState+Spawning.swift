//
//  CanvasSpawnerState+Spawning.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension CanvasSpawnerState {
    class Spawning: CanvasSpawnerState {
        private var complete = false

        override func getStateTransition() -> State? {
            Idle(spawner: spawner, idleTime: 10)
        }

        override func getBehaviour() -> StateBehaviour {
            if !complete {
                complete = true
                return SpawnCanvasBehaviour()
            }

            return DoNothingBehaviour()
        }
    }
}

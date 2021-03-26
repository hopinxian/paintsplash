//
//  EnemySpawnerState+Spawning.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension EnemySpawnerState {
    class Spawning: EnemySpawnerState {
        private var complete = false

        override func onEnterState() {
            spawner.animationComponent.animate(
                animation: SpawnerAnimations.spawnerSpawn,
                interupt: true,
                callBack: {
                    self.spawner.stateComponent.currentState =
                        Idle(spawner: self.spawner, idleTime: 3.0)
                }
            )
        }

        override func getBehaviour() -> StateBehaviour {
            if !complete {
                complete = true
                return SpawnEnemyBehaviour(spawnQuantity: 1)
            }

            return DoNothingBehaviour()
        }
    }

    class Hit: EnemySpawnerState {
        override func onEnterState() {
            spawner.animationComponent.animate(
                animation: SpawnerAnimations.spawnerHit,
                interupt: true,
                callBack: {
                    self.spawner.stateComponent.currentState = Idle(spawner: self.spawner, idleTime: 3.0)
                }
            )
        }
    }
}

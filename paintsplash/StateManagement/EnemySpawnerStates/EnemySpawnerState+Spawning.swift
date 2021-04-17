//
//  EnemySpawnerState+Spawning.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

extension EnemySpawnerState {
    class Spawning: EnemySpawnerState {
        private var complete = false
        private var animationComplete = false

        override func onEnterState() {
            spawner.animationComponent.animate(
                animation: SpawnerAnimations.spawnerSpawn,
                interupt: true,
                callBack: { [weak self] in
                    self?.animationComplete = true
                }
            )
        }

        override func getStateTransition() -> State? {
            if complete && animationComplete {
                return Idle(
                    spawner: self.spawner,
                    idleTime: Constants.ENEMY_SPAWNER_INTERVAL
                )
            }

            return nil
        }

        override func getBehaviour() -> StateBehaviour {
            if !complete && animationComplete {
                complete = true
                return SpawnEnemyBehaviour(spawnQuantity: 1)
            }

            return DoNothingBehaviour()
        }
    }
}

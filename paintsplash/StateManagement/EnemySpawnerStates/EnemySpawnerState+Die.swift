//
//  EnemySpawnerState+Die.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//
extension EnemySpawnerState {
    class Die: EnemySpawnerState {
        override func onEnterState() {
            spawner.animationComponent.animate(
                animation: SpawnerAnimations.spawnerSpawn,
                interupt: true, callBack: { self.spawner.destroy() }
            )
        }

        override func getStateTransition() -> State? {
            Idle(spawner: spawner, idleTime: 100)
        }

        override func getBehaviour() -> StateBehaviour {
            SpawnEnemyBehaviour(spawnQuantity: 1)
        }
    }
}

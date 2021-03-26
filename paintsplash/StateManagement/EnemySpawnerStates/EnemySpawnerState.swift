//
//  EnemySpawnerState.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class EnemySpawnerState: State {
    let spawner: EnemySpawner

    init(spawner: EnemySpawner) {
        self.spawner = spawner
    }
}

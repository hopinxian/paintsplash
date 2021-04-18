//
//  EnemySpawnerState.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

/// The base class for an enemy spawner state.
class EnemySpawnerState: State {
    unowned let spawner: EnemySpawner

    init(spawner: EnemySpawner) {
        self.spawner = spawner
    }
}

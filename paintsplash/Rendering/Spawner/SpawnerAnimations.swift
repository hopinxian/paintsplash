//
//  SpawnerAnimations.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//

struct SpawnerAnimations {
    static let spawnerIdle = Animation(atlasName: "SpawnerIdle", name: "spawnerIdle", isRepeating: true)
    static let spawnerSpawn = Animation(atlasName: "SpawnerSpawn", name: "spawnerSpawn", isRepeating: false)
    static let spawnerDie = Animation(atlasName: "SpawnerDie", name: "spawnerDie", isRepeating: false)
    static let spawnerHit = Animation(atlasName: "SpawnerHit", name: "spawnerHit", isRepeating: true)
}

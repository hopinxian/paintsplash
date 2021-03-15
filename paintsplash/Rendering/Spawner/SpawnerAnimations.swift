//
//  SpawnerAnimations.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//

struct SpawnerAnimations {
    static let spawnerIdle = AtlasAnimation(atlasName: "SpawnerIdle", name: "spawnerIdle", animationDuration: 1.2, isRepeating: true)
    static let spawnerSpawn = AtlasAnimation(atlasName: "SpawnerSpawn", name: "spawnerSpawn", animationDuration: 1.2, isRepeating: false)
    static let spawnerDie = AtlasAnimation(atlasName: "SpawnerDie", name: "spawnerDie", animationDuration: 1.2, isRepeating: false)
    static let spawnerHit = AtlasAnimation(atlasName: "SpawnerHit", name: "spawnerHit", animationDuration: 1.2, isRepeating: true)
}

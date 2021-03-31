//
//  SpawnerAnimations.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//

struct SpawnerAnimations {
    static let spawnerIdle =
        AtlasAnimation(name: "spawnerIdle",
                       animationDuration: 1.2, atlasName: "SpawnerIdle", isRepeating: true)
    static let spawnerSpawn =
        AtlasAnimation(name: "spawnerSpawn",
                       animationDuration: 1.2, atlasName: "SpawnerSpawn", isRepeating: false)
    static let spawnerDie =
        AtlasAnimation(name: "spawnerDie",
                       animationDuration: 1.2, atlasName: "SpawnerDie", isRepeating: false)
    static let spawnerHit =
        AtlasAnimation(name: "spawnerHit",
                       animationDuration: 1.2, atlasName: "SpawnerHit", isRepeating: true)
}

//
//  SpawnerAnimations.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//

struct SpawnerAnimations: AnimationSource {
    var animations: [String: Animation] = [
        "spawnerIdle":
            AtlasAnimation(
                name: "spawnerIdle",
                animationDuration: 1.2,
                atlasName: "SpawnerIdle",
                isRepeating: true
            ),
        "spawnerSpawn":
            AtlasAnimation(
                name: "spawnerSpawn",
                animationDuration: 2.0,
                atlasName: "SpawnerSpawn",
                isRepeating: false
            ),
        "spawnerDie":
            AtlasAnimation(
                name: "spawnerDie",
                animationDuration: 1.2,
                atlasName: "SpawnerDie",
                isRepeating: false
            ),
        "spawnerHit":
            AtlasAnimation(
                name: "spawnerHit",
                animationDuration: 1.2,
                atlasName: "SpawnerHit",
                isRepeating: true
            )
    ]

    static let spawnerIdle = "spawnerIdle"
    static let spawnerSpawn = "spawnerSpawn"
    static let spawnerDie = "spawnerDie"
    static let spawnerHit = "spawnerHit"
}

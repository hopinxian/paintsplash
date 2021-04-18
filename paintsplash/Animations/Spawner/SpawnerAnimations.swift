//
//  SpawnerAnimations.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//
import SpriteKit

struct SpawnerAnimations: AnimationSource {
    var animations: [String: Animation] = [
        "spawnerIdle":
            AtlasAnimation(
                name: "spawnerIdle",
                animationDuration: 1.2,
                atlasName: "SpawnerIdle",
                isRepeating: true
            ),
        "spawnerSpawn": AtlasAnimation(
                name: "spawnerSpawn",
                animationDuration: 2.0,
                atlasName: "SpawnerSpawn",
                isRepeating: false
            ),
        "spawnerDie": CompoundAnimation(
            name: "spawnerDie",
            animations: [
                AtlasAnimation(
                    name: "spawnerDie",
                    animationDuration: 0.5,
                    // TODO: spawner die atlas not recognised by xcode :(
                    atlasName: "SpawnerIdle",
                    isRepeating: false
                ),
                RawAnimation(
                    name: "spawnerFade",
                    action: SKAction.fadeOut(withDuration: 0.5)
                )
            ]
        ),
        "spawnerHit":
            RawAnimation(name: "spawnerHit",
                         action: SKAction.repeat(SKAction.sequence([
                            SKAction.fadeAlpha(to: 0.4, duration: 0.05),
                            SKAction.fadeAlpha(to: 1.0, duration: 0.05)
                         ]), count: 3))
    ]

    static let spawnerIdle = "spawnerIdle"
    static let spawnerSpawn = "spawnerSpawn"
    static let spawnerDie = "spawnerDie"
    static let spawnerHit = "spawnerHit"
}

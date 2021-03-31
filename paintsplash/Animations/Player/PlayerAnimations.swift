//
//  PlayerAnimations.swift
//  paintsplash
//
//  Created by Praveen Bala on 17/3/21.
//

struct PlayerAnimations {
    // Attack
    static let playerBrushAttackLeft =
        AtlasAnimation(name: "playerBrushAttackLeft",
                       animationDuration: 0.5,
                       atlasName: "PlayerBrushAttackLeft",
                       isRepeating: false)

    static let playerBrushAttackRight =
        AtlasAnimation(name: "playerBrushAttackRight",
                       animationDuration: 0.5,
                       atlasName: "PlayerBrushAttackRight",
                       isRepeating: false)

    // Idle
    static let playerBrushIdleLeft =
        AtlasAnimation(name: "playerBrushIdleLeft",
                       animationDuration: 1.2,
                       atlasName: "PlayerBrushIdleLeft",
                       isRepeating: true)

    static let playerBrushIdleRight =
        AtlasAnimation(name: "layerBrushIdleRight",
                       animationDuration: 1.2,
                       atlasName: "PlayerBrushIdleRight",
                       isRepeating: true)

    // Walk
    static let playerBrushWalkLeft =
        AtlasAnimation(name: "playerBrushWalkLeft",
                       animationDuration: 1.2,
                       atlasName: "PlayerBrushWalkLeft",
                       isRepeating: true)

    static let playerBrushWalkRight =
        AtlasAnimation(name: "playerBrushWalkRight",
                       animationDuration: 1.2,
                       atlasName: "PlayerBrushWalkRight",
                       isRepeating: true)

    // Death
    static let playerDie =
        AtlasAnimation(name: "playerDie",
                       animationDuration: 1.0,
                       atlasName: "PlayerDie",
                       isRepeating: false)
}

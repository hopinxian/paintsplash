//
//  PlayerAnimations.swift
//  paintsplash
//
//  Created by Praveen Bala on 17/3/21.
//

struct PlayerAnimations {
    // Attack
    static let playerBrushAttackLeft =
        AtlasAnimation(atlasName: "PlayerBrushAttackLeft", name: "playerBrushAttackLeft",
                       animationDuration: 0.5, isRepeating: false)

    static let playerBrushAttackRight =
        AtlasAnimation(atlasName: "PlayerBrushAttackRight", name: "playerBrushAttackRight",
                       animationDuration: 0.5, isRepeating: false)

    // Idle
    static let playerBrushIdleLeft =
        AtlasAnimation(atlasName: "PlayerBrushIdleLeft", name: "playerBrushIdleLeft",
                       animationDuration: 1.2, isRepeating: true)

    static let playerBrushIdleRight =
        AtlasAnimation(atlasName: "PlayerBrushIdleRight", name: "layerBrushIdleRight",
                       animationDuration: 1.2, isRepeating: true)

    // Walk
    static let playerBrushWalkLeft =
        AtlasAnimation(atlasName: "PlayerBrushWalkLeft", name: "playerBrushWalkLeft",
                       animationDuration: 1.2, isRepeating: true)
    static let playerBrushWalkRight =
        AtlasAnimation(atlasName: "PlayerBrushWalkRight", name: "playerBrushWalkRight",
                       animationDuration: 1.2, isRepeating: true)

    // Death
    static let playerDie = AtlasAnimation(atlasName: "PlayerDie", name: "playerDie",
                                          animationDuration: 1.0, isRepeating: false)
}

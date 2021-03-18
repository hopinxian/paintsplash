//
//  PlayerAnimations.swift
//  paintsplash
//
//  Created by Praveen Bala on 17/3/21.
//

struct PlayerAnimations {
    // Attack
    static let playerBrushAttackLeft = AtlasAnimation(atlasName: "PlayerBrushAttackLeft", name: "playerBrushAttackLeft", animationDuration: 1.2, isRepeating: false)
    static let playerBrushAttackRight = AtlasAnimation(atlasName: "PlayerBrushAttackRight", name: "playerBrushAttackRight", animationDuration: 1.2, isRepeating: false)

    // Idle
    static let playerBrushIdleLeft = AtlasAnimation(atlasName: "PlayerBrushIdleLeft", name: "playerBrushIdleLeft", animationDuration: 1.2, isRepeating: true)
    static let playerBrushIdleRight = AtlasAnimation(atlasName: "PlayerBrushIdleRight", name: "layerBrushIdleRight", animationDuration: 1.2, isRepeating: false)

    // Walk
    static let playerBrushWalkLeft = AtlasAnimation(atlasName: "PlayerBrushWalkLeft", name: "playerBrushWalkLeft", animationDuration: 1.2, isRepeating: true)
    static let playerBrushWalkRight = AtlasAnimation(atlasName: "PlayerBrushWalkRight", name: "playerBrushWalkRight", animationDuration: 1.2, isRepeating: true)

    // Death
    static let playerDie = AtlasAnimation(atlasName: "SlimeDie", name: "slimeDie", animationDuration: 1.2, isRepeating: false)
}

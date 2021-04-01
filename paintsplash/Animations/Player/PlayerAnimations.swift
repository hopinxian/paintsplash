//
//  PlayerAnimations.swift
//  paintsplash
//
//  Created by Praveen Bala on 17/3/21.
//

struct PlayerAnimations: AnimationSource {
    var animations: [String: Animation] = [
        "playerBrushAttackLeft":
            AtlasAnimation(name: "playerBrushAttackLeft",
                           animationDuration: 0.5,
                           atlasName: "PlayerBrushAttackLeft",
                           isRepeating: false),
        "playerBrushAttackRight":
            AtlasAnimation(name: "playerBrushAttackRight",
                           animationDuration: 0.5,
                           atlasName: "PlayerBrushAttackRight",
                           isRepeating: false),
        "playerBrushIdleLeft":
            AtlasAnimation(name: "playerBrushIdleLeft",
                           animationDuration: 1.2,
                           atlasName: "PlayerBrushIdleLeft",
                           isRepeating: true),
        "playerBrushIdleRight":
            AtlasAnimation(name: "layerBrushIdleRight",
                           animationDuration: 1.2,
                           atlasName: "PlayerBrushIdleRight",
                           isRepeating: true),
        "playerBrushWalkLeft":
            AtlasAnimation(name: "playerBrushWalkLeft",
                           animationDuration: 1.2,
                           atlasName: "PlayerBrushWalkLeft",
                           isRepeating: true),
        "playerBrushWalkRight":
            AtlasAnimation(name: "playerBrushWalkRight",
                           animationDuration: 1.2,
                           atlasName: "PlayerBrushWalkRight",
                           isRepeating: true),
        "playerDie":
            AtlasAnimation(name: "playerDie",
                           animationDuration: 1.0,
                           atlasName: "PlayerDie",
                           isRepeating: false)
    ]

    static let playerBrushAttackLeft = "playerBrushAttackLeft"
    static let playerBrushAttackRight = "playerBrushAttackRight"
    static let playerBrushIdleLeft = "playerBrushIdleLeft"
    static let playerBrushIdleRight = "playerBrushIdleRight"
    static let playerBrushWalkLeft = "playerBrushWalkLeft"
    static let playerBrushWalkRight = "playerBrushWalkRight"
    static let playerDie = "playerDie"
}

//
//  SlimeAnimations.swift
//  paintsplash
//
//  Created by Farrell Nah on 13/3/21.
//
import SpriteKit

struct SlimeAnimations: AnimationSource {
    var animations: [String: Animation] = [
        "slimeMoveRight":
            AtlasAnimation(
                name: "slimeMoveRight",
                animationDuration: 0.8,
                atlasName: "SlimeMoveRight",
                isRepeating: true
            ),
        "slimeMoveLeft":
            AtlasAnimation(
                name: "slimeMoveLeft",
                animationDuration: 0.8,
                atlasName: "SlimeMoveLeft",
                isRepeating: true
            ),
        "slimeIdleLeft":
            AtlasAnimation(
                name: "slimeIdleLeft",
                animationDuration: 0.8,
                atlasName: "SlimeIdleLeft",
                isRepeating: true
            ),
        "slimeIdleRight":
            AtlasAnimation(name: "slimeIdleRight",
                           animationDuration: 0.8,
                           atlasName: "SlimeIdleRight",
                           isRepeating: true),
        "slimeDie": CompoundAnimation(
            name: "slideDie",
            animations: [
                AtlasAnimation(
                    name: "slimeDie",
                    animationDuration: 0.5,
                    atlasName: "SlimeDie",
                    isRepeating: false
                ),
                RawAnimation(
                    name: "slimeFade",
                    action: SKAction.fadeOut(withDuration: 1.2)
                )
            ]
        ),
        "slimeHit":
            AtlasAnimation(
                name: "slimeHit",
                animationDuration: 1.2,
                atlasName: "SlimeHit",
                isRepeating: false
            )
    ]

    static let slimeMoveRight = "slimeMoveRight"
    static let slimeMoveLeft = "slimeMoveLeft"
    static let slimeIdleLeft = "slimeIdleLeft"
    static let slimeIdleRight = "slimeIdleRight"
    static let slimeDie = "slimeDie"
    static let slimeHit = "slimeHit"
}

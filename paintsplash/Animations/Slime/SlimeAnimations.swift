//
//  SlimeAnimations.swift
//  paintsplash
//
//  Created by Farrell Nah on 13/3/21.
//
import SpriteKit

struct SlimeAnimations: AnimationSource {
    var animations: [String : Animation] = [
        "slimeMoveRightGray":
            AtlasAnimation(
                name: "slimeMoveRightGray",
                animationDuration: 0.8,
                atlasName: "SlimeMoveRightGray",
                isRepeating: true
            ),
        "slimeMoveLeftGray":
            AtlasAnimation(
                name: "slimeMoveLeftGray",
                animationDuration: 0.8,
                atlasName: "SlimeMoveLeftGray",
                isRepeating: true
            ),
        "slimeIdleGray":
            AtlasAnimation(
                name: "slimeIdleGray",
                animationDuration: 0.8,
                atlasName: "SlimeIdleGray",
                isRepeating: true
            ),
        "slimeDieGray": CompoundAnimation(
            name: "slideDieGray",
            animations: [
                AtlasAnimation(
                    name: "slimeDieGray",
                    animationDuration: 0.5,
                    atlasName: "SlimeDieGray",
                    isRepeating: false
                ),
                RawAnimation(
                    name: "slimeFade",
                    action: SKAction.fadeOut(withDuration: 1.2)
                )
            ]
        ),
        "slimeHitGray":
            AtlasAnimation(
                name: "slimeHitGray",
                animationDuration: 1.2,
                atlasName: "SlimeHitGray",
                isRepeating: false
            )
    ]

    static let slimeMoveRightGray = "slimeMoveRightGray"
    static let slimeMoveLeftGray = "slimeMoveLeftGray"
    static let slimeIdleGray = "slimeIdleGray"
    static let slimeDieGray = "slimeDieGray"
    static let slimeHitGray = "slimeHitGray"
}

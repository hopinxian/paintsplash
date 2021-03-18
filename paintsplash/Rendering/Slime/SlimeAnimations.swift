
//
//  SlimeAnimations.swift
//  paintsplash
//
//  Created by Farrell Nah on 13/3/21.
//
struct SlimeAnimations {
    static let slimeMoveRight = AtlasAnimation(atlasName: "SlimeMoveRight", name: "slimeMoveRight", animationDuration: 1.2, isRepeating: true)
    static let slimeMoveLeft = AtlasAnimation(atlasName: "SlimeMoveLeft", name: "slimeMoveLeft", animationDuration: 1.2, isRepeating: true)
    static let slimeIdle = AtlasAnimation(atlasName: "SlimeIdle", name: "slimeIdle", animationDuration: 1.2, isRepeating: true)
    static let slimeDie = AtlasAnimation(atlasName: "SlimeDie", name: "slimeDie", animationDuration: 1.2, isRepeating: false)
    static let slimeHit = AtlasAnimation(atlasName: "SlimeHit", name: "slimeHit", animationDuration: 1.2, isRepeating: true)
    
    static let slimeMoveRightGray = AtlasAnimation(atlasName: "SlimeMoveRightGray", name: "slimeMoveRightGray", animationDuration: 1.2, isRepeating: true)
    static let slimeMoveLeftGray = AtlasAnimation(atlasName: "SlimeMoveLeftGray", name: "slimeMoveLeftGray", animationDuration: 1.2, isRepeating: true)
    static let slimeIdleGray = AtlasAnimation(atlasName: "SlimeIdleGray", name: "slimeIdleGray", animationDuration: 1.2, isRepeating: true)
    static let slimeDieGray = CompoundAnimation(
        name: "slideDieGray",
        animations: [
            AtlasAnimation(atlasName: "SlimeDieGray", name: "slimeDieGray", animationDuration: 1.2, isRepeating: false),
            FadeOutAnimation(name: "slideDieGray", animationDuration: 1.2)
        ]
    )

    static let slimeHitGray = AtlasAnimation(atlasName: "SlimeHitGray", name: "slimeHitGray", animationDuration: 1.2, isRepeating: true)
        
}

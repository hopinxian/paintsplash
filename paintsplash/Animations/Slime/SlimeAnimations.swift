//
//  SlimeAnimations.swift
//  paintsplash
//
//  Created by Farrell Nah on 13/3/21.
//

struct SlimeAnimations {
    static let slimeMoveRightGray =
        AtlasAnimation(name: "slimeMoveRightGray",
                       animationDuration: 0.8, atlasName: "SlimeMoveRightGray", isRepeating: true)
    static let slimeMoveLeftGray =
        AtlasAnimation(name: "slimeMoveLeftGray",
                       animationDuration: 0.8, atlasName: "SlimeMoveLeftGray", isRepeating: true)
    static let slimeIdleGray =
        AtlasAnimation(name: "slimeIdleGray",
                       animationDuration: 0.8, atlasName: "SlimeIdleGray", isRepeating: true)
    static let slimeDieGray = CompoundAnimation(
        name: "slideDieGray",
        animations: [
            AtlasAnimation(name: "slimeDieGray", animationDuration: 0.5, atlasName: "SlimeDieGray", isRepeating: false),
            FadeOutAnimation(name: "slideDieGray", duration: 1.2)
        ]
    )

    static let slimeHitGray =
        AtlasAnimation(name: "slimeHitGray",
                       animationDuration: 1.2, atlasName: "SlimeHitGray", isRepeating: false)

}

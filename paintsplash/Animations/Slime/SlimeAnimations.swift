//
//  SlimeAnimations.swift
//  paintsplash
//
//  Created by Farrell Nah on 13/3/21.
//

struct SlimeAnimations {
    static let slimeMoveRightGray =
        AtlasAnimation(atlasName: "SlimeMoveRightGray", name: "slimeMoveRightGray",
                       animationDuration: 0.8, isRepeating: false)
    static let slimeMoveLeftGray =
        AtlasAnimation(atlasName: "SlimeMoveLeftGray", name: "slimeMoveLeftGray",
                       animationDuration: 0.8, isRepeating: false)
    static let slimeIdleGray =
        AtlasAnimation(atlasName: "SlimeIdleGray", name: "slimeIdleGray",
                       animationDuration: 0.8, isRepeating: false)
    static let slimeDieGray = CompoundAnimation(
        name: "slideDieGray",
        animations: [
            AtlasAnimation(atlasName: "SlimeDieGray", name: "slimeDieGray", animationDuration: 0.5, isRepeating: false),
            FadeOutAnimation(name: "slideDieGray", animationDuration: 1.2)
        ]
    )

    static let slimeHitGray =
        AtlasAnimation(atlasName: "SlimeHitGray", name: "slimeHitGray",
                       animationDuration: 1.2, isRepeating: false)

}

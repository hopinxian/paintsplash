//
//  SlimeAnimations.swift
//  paintsplash
//
//  Created by Farrell Nah on 13/3/21.
//

struct SlimeAnimations {
    static let slimeMoveRight = Animation(atlasName: "SlimeMoveRight", name: "slimeMoveRight", isRepeating: true)
    static let slimeMoveLeft = Animation(atlasName: "SlimeMoveLeft", name: "slimeMoveLeft", isRepeating: true)
    static let slimeIdle = Animation(atlasName: "SlimeIdle", name: "slimeIdle", isRepeating: true)
    static let slimeDie = Animation(atlasName: "SlimeDie", name: "slimeDie", isRepeating: false)
    static let slimeHit = Animation(atlasName: "SlimeHit", name: "slimeHit", isRepeating: true)
}

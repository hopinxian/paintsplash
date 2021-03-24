//
//  SequenceAnimation.swift
//  paintsplash
//
//  Created by Farrell Nah on 20/3/21.
//
import SpriteKit

struct SequenceAnimation: Animation {
    let name: String
    let animationDuration: Double = 0
    let animations: [Animation]

    func getAction() -> SKAction {
        SKAction.sequence(animations.compactMap({ $0.getAction() }))
    }
}

//
//  CompoundAnimation.swift
//  paintsplash
//
//  Created by Farrell Nah on 20/3/21.
//
import SpriteKit

class CompoundAnimation: Animation {
    let animations: [Animation]

    init(name: String, animations: [Animation]) {
        self.animations = animations
        super.init(name: name)
    }

    override func getAction() -> SKAction {
        SKAction.group(animations.compactMap({ $0.getAction() }))
    }
}

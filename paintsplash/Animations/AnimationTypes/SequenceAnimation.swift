//
//  SequenceAnimation.swift
//  paintsplash
//
//  Created by Farrell Nah on 20/3/21.
//
import SpriteKit

class SequenceAnimation: Animation {
    let animations: [Animation]

    init(name: String, animations: [Animation]) {
        self.animations = animations
        super.init(name: name)
    }
}

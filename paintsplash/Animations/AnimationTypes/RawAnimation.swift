//
//  RawAnimation.swift
//  paintsplash
//
//  Created by Farrell Nah on 31/3/21.
//
import SpriteKit

class RawAnimation: Animation {
    var action: SKAction

    init(name: String, action: SKAction) {
        self.action = action
        super.init(name: name)
    }

    override func getAction() -> SKAction {
        action
    }
}

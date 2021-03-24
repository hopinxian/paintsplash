//
//  CallbackAnimation.swift
//  paintsplash
//
//  Created by Farrell Nah on 20/3/21.
//
import SpriteKit

struct CallbackAnimation: Animation {
    let name: String
    let animationDuration: Double
    let animation: Animation
    var completionCallback: (() -> Void)

    func getAction() -> SKAction {
        SKAction.sequence([animation.getAction(), SKAction.run(completionCallback)])
    }
}

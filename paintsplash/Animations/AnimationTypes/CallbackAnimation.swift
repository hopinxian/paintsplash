//
//  CallbackAnimation.swift
//  paintsplash
//
//  Created by Farrell Nah on 20/3/21.
//
import SpriteKit

class CallbackAnimation: Animation {
    let animation: Animation
    var completionCallback: (() -> Void)

    init(
        name: String,
        animation: Animation,
        completionCallback: @escaping () -> Void
    ) {
        self.animation = animation
        self.completionCallback = completionCallback
        super.init(name: name)
    }

    override func getAction() -> SKAction {
        SKAction.sequence([animation.getAction(), SKAction.run(completionCallback)])
    }
}

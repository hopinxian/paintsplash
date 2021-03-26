//
//  AnimationComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class AnimationComponent: Component {
    var currentAnimation: Animation?
    var animationToPlay: Animation?
    var animationIsPlaying: Bool = false

    func animate(animation: Animation, interupt: Bool) {
        animate(animation: animation, interupt: interupt, callBack: nil)
    }

    func animate(animation: Animation, interupt: Bool, callBack: (() -> Void)?) {
        if !animationIsPlaying || interupt {
            animationToPlay = CallbackAnimation(
                name: animation.name,
                animationDuration: animation.animationDuration,
                animation: animation,
                completionCallback: { [weak self] in
                    self?.animationIsPlaying = false
                    callBack?()
                }
            )
        }
    }
}

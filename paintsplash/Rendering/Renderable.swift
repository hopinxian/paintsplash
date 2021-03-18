//
//  Renderable.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import SpriteKit

protocol Renderable: GameEntity, Transformable {
    var spriteName: String { get }
    var defaultAnimation: Animation? { get }
    var zPosition: Int { get set }

    func animate(animation: Animation, interupt: Bool)
    func animate(animation: Animation, interupt: Bool, callBack: (() -> Void)?)
}

extension Renderable {
    var zPosition: Int {
        get {
            0
        }

        set {
            zPosition = newValue
        }
    }

    func animate(animation: Animation, interupt: Bool) {
        animate(animation: animation, interupt: interupt, callBack: nil)
    }

    func animate(animation: Animation, interupt: Bool, callBack: (() -> Void)?) {
//        currentAnimation = animation
        var processedAnimation = animation
        if let callback = callBack {
            processedAnimation = CallbackAnimation(
                name: animation.name,
                animationDuration: animation.animationDuration,
                animation: animation,
                completionCallback: callback
            )
        }

        EventSystem
            .changeViewEvent
            .changeAnimationEvent.post(
                event: ChangeAnimationEvent(
                    renderable: self,
                    animation: processedAnimation,
                    interrupt: interupt
                )
            )
    }
}

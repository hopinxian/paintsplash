//
//  UpdateAnimationBehaviour.swift
//  paintsplash
//
//  Created by Farrell Nah on 24/3/21.
//

struct UpdateAnimationBehaviour: AIBehaviour {
    let animation: Animation
    let interupt: Bool

    func updateAI(aiEntity: AIEntity, aiGameInfo: AIGameInfo) {
        guard let animatable = aiEntity as? Animatable else {
            fatalError("AIEntity does not conform to the protocols required for UpdateAnimationBehaviour")
        }

        animatable.animationComponent.animate(animation: animation, interupt: interupt)
    }
}

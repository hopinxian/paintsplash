//
//  AnimationSystemData.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//

struct AnimationSystemData: Codable {
    var animatables = [EntityID: EncodableAnimatable]()

    init(from data: [EntityID: Animatable]) {
        data.forEach({ entity, animatable in
            self.animatables[entity] = EncodableAnimatable(
                entityID: entity,
                animationComponent: animatable.animationComponent
            )
        })
    }
}

//
//  AnimationSystemData.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//

struct AnimationSystemData: Codable {
    var animatables = [EntityID: EncodableAnimatable]()

    init(from data: [EntityID: Animatable]) {
        data.forEach { addAnimatable(id: $0, animatable: $1) }
    }

    private mutating func addAnimatable(id: EntityID, animatable: Animatable) {
        self.animatables[id] = EncodableAnimatable(
            entityID: id,
            animationComponent: animatable.animationComponent
        )
    }
}

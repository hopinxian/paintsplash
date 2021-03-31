//
//  RenderSystemData.swift
//  paintsplash
//
//  Created by Farrell Nah on 31/3/21.
//
import Foundation

struct EncodableRenderable: Codable {
    let entityID: UUID
    let renderComponent: RenderComponent
    let transformComponent: TransformComponent
}

struct RenderSystemData: Codable {
    let renderables: [EncodableRenderable]

    init(from renderSystem: RenderSystem) {
        self.renderables = renderSystem.renderables.map({ entity, renderable in
            EncodableRenderable(entityID: entity.id, renderComponent: renderable.renderComponent, transformComponent: renderable.transformComponent)
        })
    }
}

struct EncodableAnimatable: Codable {
    let entityID: UUID
    let animationComponent: AnimationComponent
}

struct AnimationSystemData: Codable {
    let animatables: [EncodableAnimatable]

    init(from animationSystem: AnimationSystem) {
        self.animatables = animationSystem.animatables.map({ entity, animatable in
            let encoded = EncodableAnimatable(entityID: entity.id, animationComponent: animatable.animationComponent)
            return encoded
        })
    }
}

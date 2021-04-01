//
//  RenderSystemData.swift
//  paintsplash
//
//  Created by Farrell Nah on 31/3/21.
//
import Foundation

struct EncodableRenderable: Codable {
    let entityID: EntityID
    let renderComponent: RenderComponent
    let transformComponent: TransformComponent
}

struct RenderSystemData: Codable {
    let renderables: [EncodableRenderable]

    init(from renderSystem: RenderSystem) {
        self.renderables = renderSystem.renderables.map({ entity, renderable in
            EncodableRenderable(entityID: entity, renderComponent: renderable.renderComponent, transformComponent: renderable.transformComponent)
        })
    }
}

struct EncodableAnimatable: Codable {
    let entityID: EntityID
    let animationComponent: AnimationComponent
}

struct AnimationSystemData: Codable {
    let animatables: [EncodableAnimatable]

    init(from animationSystem: AnimationSystem) {
        self.animatables = animationSystem.animatables.map({ entity, animatable in
            EncodableAnimatable(entityID: entity, animationComponent: animatable.animationComponent)
        })
    }
}

struct EncodableColorable: Codable {
    let entityID: EntityID
    let color: PaintColor
}

struct ColorSystemData: Codable {
    let colorables: [EncodableColorable]

    init(from colorables: [GameEntity: Colorable]) {
        self.colorables = colorables.map({ entity, colorable in
            EncodableColorable(entityID: entity.id, color: colorable.color)
        })
    }
}

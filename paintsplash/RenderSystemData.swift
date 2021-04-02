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
    var renderables = [EntityID: EncodableRenderable]()

    init(from data: [EntityID: Renderable]) {
        data.forEach({ entity, renderable in
            self.renderables[entity] = EncodableRenderable(
                entityID: entity, 
                renderComponent: renderable.renderComponent, 
                transformComponent: renderable.transformComponent
            )
        })
    }
}

struct EncodableAnimatable: Codable {
    let entityID: EntityID
    let animationComponent: AnimationComponent
    let callbackId: CallbackId?
}

struct AnimationSystemData: Codable {
    var animatables = [EntityID: EncodableAnimatable]()

    init(from data: [EntityID: Animatable]) {
        data.forEach({ entity, animatable in
            var callbackId: CallbackId? = nil
            if let callback = animatable.animationComponent.callBack {
                callbackId = ClientCallback.manager.addCallback(callback: callback)
            }
            self.animatables[entity] = EncodableAnimatable(
                entityID: entity,
                animationComponent: animatable.animationComponent,
                callbackId: callbackId
            )
        })
    }
}

struct EncodableColorable: Codable {
    let entityID: EntityID
    let color: PaintColor
}

struct ColorSystemData: Codable {
    var colorables = [EntityID: EncodableColorable]()

    init(from colorables: [EntityID: Colorable]) {
        colorables.forEach({ entity, colorable in
            self.colorables[entity] = EncodableColorable(entityID: entity, color: colorable.color)
        })
    }
}

struct EntityData: Codable {
    let entities: [EntityID]

    init(from entities: [GameEntity]) {
        self.entities = entities.map({ $0.id })
    }
}

struct SystemData: Codable {
    let entityData: EntityData
    let renderSystemData: RenderSystemData
    let animationSystemData: AnimationSystemData
    let colorSystemData: ColorSystemData
}

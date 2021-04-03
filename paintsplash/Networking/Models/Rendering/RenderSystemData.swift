//
//  RenderSystemData.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//

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

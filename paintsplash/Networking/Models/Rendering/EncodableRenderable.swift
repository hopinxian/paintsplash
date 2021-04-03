//
//  EncodableRenderable.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//

struct EncodableRenderable: Codable {
    let entityID: EntityID
    let renderComponent: RenderComponent
    let transformComponent: TransformComponent
}

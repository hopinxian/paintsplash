//
//  RenderComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 20/3/21.
//

class RenderComponent: Component, Codable {
    var renderType: RenderType
    var zPosition: Int
    var cropInParent: Bool

    init(renderType: RenderType, zPosition: Int, cropInParent: Bool = false) {
        self.renderType = renderType
        self.zPosition = zPosition
        self.cropInParent = cropInParent
    }
}

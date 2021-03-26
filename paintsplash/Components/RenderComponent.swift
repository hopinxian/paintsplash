//
//  RenderComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 20/3/21.
//

class RenderComponent: Component {
    var renderType: RenderType
    var zPosition: Int

    init(renderType: RenderType, zPosition: Int) {
        self.renderType = renderType
        self.zPosition = zPosition
    }
}

class ColorComponent: Component {
    var color: PaintColor

    init(color: PaintColor) {
        self.color = color
    }
}

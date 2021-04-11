//
//  LightDisplay.swift
//  paintsplash
//
//  Created by Cynthia Lee on 12/4/21.
//
class LightDisplay: UIEntity, Renderable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent

    init(size: Vector2D, position: Vector2D) {
        let renderType = RenderType.sprite(spriteName: Constants.LIGHT_DISPLAY_SPRITE)
        self.renderComponent = RenderComponent(
            renderType: renderType,
            zPosition: Constants.ZPOSITION_UI_ELEMENT + 1
        )
        self.transformComponent = TransformComponent(
            position: position,
            rotation: 0.0,
            size: size
        )

        super.init()
    }
}

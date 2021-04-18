//
//  LightDisplay.swift
//  paintsplash
//
//  Created by Cynthia Lee on 12/4/21.
//
class LightDisplay: UIEntity, Renderable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent

    init(size: Vector2D = Constants.LIGHT_DISPLAY_SIZE,
         position: Vector2D = Constants.LIGHT_DISPLAY_POSITION) {
        let renderType = RenderType.sprite(spriteName: Constants.LIGHT_DISPLAY_SPRITE)
        self.renderComponent = RenderComponent(
            renderType: renderType,
            zPosition: Constants.ZPOSITION_LIGHT,
            zPositionGroup: .background
        )
        self.transformComponent = TransformComponent(
            position: position,
            rotation: 0.0,
            size: size
        )

        super.init()
    }
}

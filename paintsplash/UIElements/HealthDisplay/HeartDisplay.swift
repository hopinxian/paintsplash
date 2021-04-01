//
//  HeartDisplay.swift
//  paintsplash
//
//  Created by Farrell Nah on 19/3/21.
//

class HeartDisplay: UIEntity, Renderable, Transformable {
    var transformComponent: TransformComponent
    var renderComponent: RenderComponent

    init(position: Vector2D, zPosition: Int) {
        let renderType = RenderType.sprite(spriteName: "heart")

        self.transformComponent = TransformComponent(
            position: position,
            rotation: 0.0,
            size: Constants.HEART_DISPLAY_SIZE
        )
        self.renderComponent = RenderComponent(renderType: renderType, zPosition: zPosition)

        super.init()
    }
}

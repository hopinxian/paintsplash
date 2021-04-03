//
//  Background.swift
//  paintsplash
//
//  Created by Farrell Nah on 29/3/21.
//

class Background: UIEntity, Renderable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent

    override init() {
        self.renderComponent = RenderComponent(
            renderType: .sprite(spriteName: "floor"),
            zPosition: Constants.ZPOSITION_FLOOR
        )

        self.transformComponent = TransformComponent(
            position: Vector2D.zero,
            rotation: 0,
            size: SpaceConverter.modelSize
        )
    }
}

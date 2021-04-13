//
//  ScoreDisplay.swift
//  paintsplash
//
//  Created by Cynthia Lee on 12/4/21.
//

class ScoreDisplay: UIEntity, Renderable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent

    init(size: Vector2D, position: Vector2D) {
        let renderType = RenderType.sprite(spriteName: Constants.SCORE_DISPLAY_SPRITE)
        self.renderComponent = RenderComponent(
            renderType: renderType,
            zPosition: Constants.ZPOSITION_SCORE
        )
        self.transformComponent = TransformComponent(
            position: position,
            rotation: 0.0,
            size: size
        )

        super.init()
    }
}

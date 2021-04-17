//
//  CanvasEndMarker.swift
//  paintsplash
//
//  Created by Cynthia Lee on 20/3/21.
//
class CanvasEndMarker: GameEntity, Renderable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent
    init(size: Vector2D = Constants.CANVAS_END_MARKER_SIZE,
         position: Vector2D = Constants.CANVAS_END_MARKER_POSITION) {
        // TODO: set zPostion to be higher than both canvas and its subviews
        let renderType = RenderType.sprite(spriteName: Constants.CANVAS_END_MARKER_SPRITE)
        self.renderComponent = RenderComponent(
            renderType: renderType,
            zPosition: 200
        )
        self.transformComponent = TransformComponent(
            position: position,
            rotation: 0.0,
            size: size
        )

        super.init()
    }
}

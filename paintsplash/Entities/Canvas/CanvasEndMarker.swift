//
//  CanvasEndMarker.swift
//  paintsplash
//
//  Created by Cynthia Lee on 20/3/21.
//
class CanvasEndMarker: GameEntity, Renderable {
    let renderComponent: RenderComponent
    let transformComponent: TransformComponent
    init(size: Vector2D, position: Vector2D) {
        // TODO: set zPostion to be higher than both canvas and its subviews
        let renderType = RenderType.sprite(spriteName: "CanvasEndMarker")
        self.renderComponent = RenderComponent(renderType: renderType, zPosition: 200)
        self.transformComponent = TransformComponent(position: position, rotation: 0.0, size: size)

        super.init()
    }
}

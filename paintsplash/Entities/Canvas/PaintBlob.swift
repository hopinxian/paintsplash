//
//  PaintBlob.swift
//  paintsplash
//
//  Created by Farrell Nah on 1/4/21.
//

class PaintBlob: GameEntity, Renderable, Transformable, Colorable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent
    var color: PaintColor

    init(color: PaintColor, canvas: Transformable & Renderable) {
        let transformComponent = canvas.transformComponent
        let renderComponent = canvas.renderComponent

        self.color = color
        self.renderComponent = RenderComponent(
            renderType: .sprite(spriteName: "paint-splash-1"),
            zPosition: renderComponent.zPosition + 1,
            zPositionGroup: renderComponent.zPositionGroup,
            cropInParent: true
        )

        let canvasWidth = transformComponent.size.x
        let canvasHeight = transformComponent.size.y
        let minBlobWidth = canvasWidth / 3
        let maxBlobWidth = canvasWidth
        let minBlobHeight = canvasHeight / 3
        let maxBlobHeight = canvasHeight

        let width = Double.random(in: minBlobWidth..<maxBlobWidth)
        let height = Double.random(in: minBlobHeight..<maxBlobHeight)
        let blobSize = Vector2D(width, height)

        let maxXPos = canvasWidth / 4
        let maxYPos = canvasHeight / 4

        let posX = Double.random(in: -(maxXPos)..<(maxXPos))
        let posY = Double.random(in: -(maxYPos)..<(maxYPos))
        let blobPos = Vector2D(posX, posY)

        // TODO: rotation?
        let rotation = Double.random(in: 0..<(Double.pi))

        self.transformComponent = TransformComponent(
            position: blobPos,
            rotation: rotation,
            size: blobSize
        )
        self.transformComponent.addParent(canvas)
    }
}

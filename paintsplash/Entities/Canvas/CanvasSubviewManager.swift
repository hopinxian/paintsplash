//
//  CanvasSubviewManager.swift
//  paintsplash
//
//  Created by Cynthia Lee on 20/3/21.
//

struct CanvasSubviewManager {
    static func getRandomPaintRenderInfo(canvasTransformable: Transformable,
                                         color: PaintColor) -> RenderInfo {
        let canvasTransform = canvasTransformable.transformComponent
        let canvasWidth = canvasTransform.size.x
        let canvasHeight = canvasTransform.size.y

        let minBlobWidth = canvasWidth / 3
        let maxBlobWidth = canvasWidth
        let minBlobHeight = canvasHeight / 3
        let maxBlobHeight = canvasHeight

        let width = Double.random(in: minBlobWidth..<maxBlobWidth)
        let height = Double.random(in: minBlobHeight..<maxBlobHeight)

        let maxXPos = canvasWidth / 4
        let maxYPos = canvasHeight / 4

        let posX = Double.random(in: -(maxXPos)..<(maxXPos))
        let posY = Double.random(in: -(maxYPos)..<(maxYPos))
        let blobPos = Vector2D(posX, posY)

        let rotation = Double.random(in: 0..<(Double.pi * 2))

        return RenderInfo(spriteName: "paint-splash-1",
                          position: blobPos,
                          width: width,
                          height: height,
                          color: color,
                          colorBlend: 0.8,
                          rotation: rotation,
                          cropInParent: true)
    }
}

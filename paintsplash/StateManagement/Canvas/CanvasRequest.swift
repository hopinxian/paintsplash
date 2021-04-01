//
//  CanvasRequests.swift
//  paintsplash
//
//  Created by Cynthia Lee on 17/3/21.
//

class CanvasRequest: GameEntity, Renderable, Transformable {
    private(set) var requiredColors: Set<PaintColor>

    var renderComponent: RenderComponent
    var transformComponent: TransformComponent

    init?(requiredColors: Set<PaintColor>, position: Vector2D) {
        if requiredColors.count < 1 {
            return nil
        }
        self.requiredColors = requiredColors

        let renderType = RenderType.sprite(spriteName: "canvas")

        self.transformComponent = TransformComponent(
            position: position,
            rotation: 0.0,
            size: Constants.CANVAS_REQUEST_SIZE
        )

        self.renderComponent = RenderComponent(
            renderType: renderType,
            zPosition: Constants.ZPOSITION_UI_ELEMENT
        )

        super.init()
    }

    func paintRequiredColours() {
        for color in requiredColors {
            // add visible paint blob to canvas
//            let blobInfo = CanvasSubviewManager.getRandomPaintRenderInfo(canvasTransformable: self,
//                                                                         color: color)
//            let addBlobEvent = AddSubviewEvent(renderable: self, renderInfo: blobInfo)
//            EventSystem.changeViewEvent.addSubviewEvent.post(event: addBlobEvent)
            let blob = PaintBlob(color: color, canvas: self)
            blob.spawn()
        }
    }
}

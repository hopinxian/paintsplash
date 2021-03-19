//
//  Canvas.swift
//  paintsplash
//
//  Created by Cynthia Lee on 16/3/21.
//

class Canvas: AIEntity {
    private(set) var colors: Set<PaintColor> = []

    // TODO: canvases of dynamic size
    init(initialPosition: Vector2D, velocity: Vector2D) {
        super.init(spriteName: "canvas", initialPosition: initialPosition, initialVelocity: velocity,
                   width: 200, height: 200)

        print("width: \(self.transform.size.x), height: \(self.transform.size.y)")

        self.currentBehaviour = CanvasBehaviour()

        self.defaultSpeed = velocity.magnitude
    }

    override func getAnimationFromState() -> Animation {
        switch self.state {
        case .idle:
            return CanvasAnimations.canvasIdle
        default:
            return CanvasAnimations.canvasIdle
        }
    }

    override func onCollide(otherObject: Collidable) {
        switch otherObject {
        case let ammo as PaintProjectile:
            let color = ammo.color
            self.colors.insert(color)

            // add visible paint blob to canvas
            let blobInfo = getPaintBlobRenderInfo(color: color)
            let addBlobEvent = AddSubviewEvent(renderable: self, renderInfo: blobInfo)
            EventSystem.changeViewEvent.addSubviewEvent.post(event: addBlobEvent)

            // post notification to alert system about colours on the current canvas
            let canvasHitEvent = CanvasHitEvent(canvas: self)
            EventSystem.canvasHitEvent.post(event: canvasHitEvent)
        default:
            print("invalid collision type")
        }

    }

    func getPaintBlobRenderInfo(color: PaintColor) -> RenderInfo {
        let canvasWidth = self.transform.size.x
        let canvasHeight = self.transform.size.y

        let width = Double.random(in: canvasWidth/5..<canvasWidth/2)
        let height = Double.random(in: canvasHeight/5..<canvasHeight/2)

        let posX = Double.random(in: -(canvasWidth/4)..<(canvasWidth/4))
        let posY = Double.random(in: -(canvasHeight/4)..<(canvasHeight/4))
        let blobPos = Vector2D(posX, posY)

        let rotation = Double.random(in: 0..<(Double.pi * 2))

        print("canvas width: \(canvasWidth), canvas height \(canvasHeight)")
        print("blob width: \(width), blob height: \(height)")
        print("blob location: \(posX), \(posY)")

        return RenderInfo(spriteName: "paint-splash-1",
                          position: blobPos,
                          width: width,
                          height: height,
                          color: color,
                          colorBlend: 1.0,
                          rotation: rotation,
                          cropInParent: true)
    }
}

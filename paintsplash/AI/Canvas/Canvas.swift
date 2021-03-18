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
                   width: 50, height: 50)
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
            print("collided with ammo")

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

        let width = Double.random(in: canvasWidth/5..<canvasWidth)
        let height = Double.random(in: canvasHeight/5..<canvasHeight)

        let posX = Double.random(in: -(canvasWidth/4)..<(canvasWidth/4))
        let posY = Double.random(in: -(canvasHeight/4)..<(canvasHeight/4))
        let blobPos = Vector2D(posX, posY)

        return RenderInfo(spriteName: "BlueCircle", position: blobPos, width: width, height: height)
    }
}

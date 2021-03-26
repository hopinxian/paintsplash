//
//  Canvas.swift
//  paintsplash
//
//  Created by Cynthia Lee on 16/3/21.
//

class Canvas: GameEntity, AIEntity, Renderable, Collidable, Transformable, Movable {
    var aiComponent: AIComponent
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent
    var collisionComponent: CollisionComponent
    var moveableComponent: MoveableComponent

    private(set) var colors: Set<PaintColor> = []
    private let moveSpeed = 1.0

    init(initialPosition: Vector2D, direction: Vector2D, size: Vector2D) {
        self.aiComponent = AIComponent(defaultState: CanvasState.Moving())
        self.renderComponent = RenderComponent(renderType: .sprite(spriteName: "canvas"),
                                               zPosition: Constants.ZPOSITION_UI_ELEMENT)
        self.transformComponent = TransformComponent(position: initialPosition, rotation: 0, size: size)
        self.collisionComponent = CollisionComponent(colliderShape: .rectangle(size: size), tags: [.canvas])
        self.moveableComponent = MoveableComponent(direction: direction, speed: moveSpeed)

        super.init()

        addComponent(aiComponent)
        addComponent(renderComponent)
        addComponent(transformComponent)
        addComponent(collisionComponent)
        addComponent(moveableComponent)
    }

    func onCollide(with: Collidable) {
        switch with {
        case let ammo as PaintProjectile:
            let color = ammo.color
            self.colors.insert(color)

            // add visible paint blob to canvas
            let blobInfo = CanvasSubviewManager.getRandomPaintRenderInfo(canvasTransformable: self,
                                                                         color: color)
            let addBlobEvent = AddSubviewEvent(renderable: self, renderInfo: blobInfo)
            EventSystem.changeViewEvent.addSubviewEvent.post(event: addBlobEvent)

            // post notification to alert system about colours on the current canvas
            let canvasHitEvent = CanvasHitEvent(canvas: self)
            EventSystem.canvasEvent.canvasHitEvent.post(event: canvasHitEvent)
        default:
            break
        }
    }
}

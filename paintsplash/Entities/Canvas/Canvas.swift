//
//  Canvas.swift
//  paintsplash
//
//  Created by Cynthia Lee on 16/3/21.
//

class Canvas: GameEntity, StatefulEntity, Renderable, Collidable, Transformable, Movable, Animatable {
    var stateComponent: StateComponent
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent
    var collisionComponent: CollisionComponent
    var moveableComponent: MoveableComponent
    var animationComponent: AnimationComponent

    var endX: Double
    private(set) var colors: Set<PaintColor> = []
    private let moveSpeed = 1.0
    private(set) var paintedColors: Set<PaintBlob> = []

    init(
        initialPosition: Vector2D,
        direction: Vector2D,
        size: Vector2D,
        endX: Double
    ) {
        self.endX = endX
        self.stateComponent = StateComponent()

        self.renderComponent = RenderComponent(
            renderType: .sprite(spriteName: "canvas"),
            zPosition: Constants.ZPOSITION_UI_ELEMENT
        )

        self.transformComponent = TransformComponent(
            position: initialPosition,
            rotation: 0,
            size: size
        )

        self.collisionComponent = CollisionComponent(
            colliderShape: .rectangle(size: size),
            tags: [.canvas]
        )

        self.moveableComponent = MoveableComponent(
            direction: direction,
            speed: moveSpeed
        )

        self.animationComponent = AnimationComponent()

        super.init()

        self.stateComponent.currentState = CanvasState.Moving(canvas: self)
    }

    func onCollide(with: Collidable) {
        switch with {
        case let ammo as PaintProjectile:
            let color = ammo.color
            self.colors.insert(color)

            let blob = PaintBlob(color: color, canvas: self)
            blob.spawn()
            paintedColors.insert(blob)

            // post notification to alert system about colours on the current canvas
            let canvasHitEvent = CanvasHitEvent(canvas: self)
            EventSystem.canvasEvent.canvasHitEvent.post(event: canvasHitEvent)
        default:
            break
        }
    }

    override func destroy() {
        paintedColors.forEach({ $0.destroy() })
        super.destroy()
    }

    deinit {
        print("canvas deinit")
    }
}

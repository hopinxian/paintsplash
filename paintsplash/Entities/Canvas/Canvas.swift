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
    var colors: Set<PaintColor> = []
    private let moveSpeed = Constants.CANVAS_MOVE_SPEED
    var paintedColors: Set<PaintBlob> = []

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

        let collisionComp = CanvasCollisionComponent(
            colliderShape: .rectangle(size: size),
            tags: [.canvas]
        )
        self.collisionComponent = collisionComp

        self.moveableComponent = MoveableComponent(
            direction: direction,
            speed: moveSpeed
        )

        self.animationComponent = AnimationComponent()

        super.init()

        self.stateComponent.currentState = CanvasState.Moving(canvas: self)

        // Assign weak references to components
        collisionComp.canvas = self
    }

    override func destroy() {
        paintedColors.forEach({ $0.destroy() })
        super.destroy()
    }

    deinit {
        print("canvas deinit")
    }
}

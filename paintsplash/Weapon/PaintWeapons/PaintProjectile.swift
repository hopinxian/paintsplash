//
//  PaintProjectile.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//
import Foundation

class PaintProjectile: GameEntity, Projectile, Renderable, Colorable, Transformable {
    var transformComponent: TransformComponent
    var moveableComponent: MoveableComponent
    var collisionComponent: CollisionComponent
    var renderComponent: RenderComponent

    var color: PaintColor

    private let moveSpeed = 15.0

    init(color: PaintColor, position: Vector2D, radius: Double, direction: Vector2D) {
        self.transformComponent = TransformComponent(
            position: position,
            rotation: 0.0,
            size: Vector2D(radius * 2, radius * 2)
        )

        self.moveableComponent = MoveableComponent(direction: direction, speed: moveSpeed)

        let collisionComp = PaintProjectileCollisionComponent(
            colliderShape: .circle(radius: radius),
            tags: [.playerProjectile]
        )
        self.collisionComponent = collisionComp

        self.renderComponent = RenderComponent(
            renderType: .sprite(spriteName: "Projectile"),
            zPosition: Constants.ZPOSITION_PROJECTILE
        )

        self.color = color

        super.init()

        // Assign weak references to components
        collisionComp.projectile = self
    }

    override func update() {
        if !Constants.PROJECTILE_MOVEMENT_BOUNDS
            .contains(transformComponent.worldPosition) {
            destroy()
        }
    }
}

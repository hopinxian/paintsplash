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

    init(color: PaintColor, radius: Double, direction: Vector2D) {
        self.transformComponent = TransformComponent(
            position: Vector2D.zero,
            rotation: 0.0,
            size: Vector2D(radius * 2, radius * 2)
        )

        self.moveableComponent = MoveableComponent(direction: direction, speed: moveSpeed)

        self.collisionComponent = CollisionComponent(
            colliderShape: .circle(radius: radius),
            tags: [.playerProjectile]
        )

        self.renderComponent = RenderComponent(
            renderType: .sprite(spriteName: "Projectile"),
            zPosition: Constants.ZPOSITION_PROJECTILE
        )

        self.color = color

        super.init()
    }

    func onCollide(with: Collidable) {
        var destroy: Bool = false
        switch with {
        case let enemy as Enemy:
            if self.color.contains(color: enemy.color) {
                destroy = true
            }
        case let enemy as EnemySpawner:
            if self.color.contains(color: enemy.color) {
                destroy = true
            }
        case _ as Canvas:
            destroy = true
        default:
            destroy = false
        }

        if destroy {
            EventSystem.entityChangeEvents.removeEntityEvent.post(event: RemoveEntityEvent(entity: self))
        }
    }

    override func update() {
        if !Constants.PROJECTILE_MOVEMENT_BOUNDS
            .contains(transformComponent.worldPosition) {
            destroy()
        }
    }
}

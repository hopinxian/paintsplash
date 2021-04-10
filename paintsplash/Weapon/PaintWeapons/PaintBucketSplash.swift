//
//  PaintBucketSplash.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/4/21.
//
import Foundation

class PaintBucketSplash: GameEntity, Projectile, Renderable, Colorable, Transformable, Animatable {
    var transformComponent: TransformComponent
    var collisionComponent: CollisionComponent
    var renderComponent: RenderComponent
    var animationComponent: AnimationComponent

    var color: PaintColor

    init(color: PaintColor, position: Vector2D, radius: Double, direction: Vector2D) {
        self.transformComponent = TransformComponent(
            position: position,
            rotation: 0.0,
            size: Vector2D(radius * 2, radius * 2)
        )

        let collisionComp = PaintBucketSplashCollisionComponent(
            colliderShape: .circle(radius: radius),
            tags: [.playerProjectile]
        )
        self.collisionComponent = collisionComp

        self.renderComponent = RenderComponent(
            renderType: .sprite(spriteName: "Projectile"),
            zPosition: Constants.ZPOSITION_PROJECTILE
        )

        self.color = color

        self.animationComponent = AnimationComponent()

        super.init()

        // Assign weak references to components
        collisionComp.splash = self

        animationComponent.animate(
            animation: "splashFade",
            interupt: true,
            callBack: { [weak self] in self?.destroy() }
        )
    }

    override func update(_ deltaTime: Double) {
        if !Constants.PROJECTILE_MOVEMENT_BOUNDS
            .contains(transformComponent.worldPosition) {
            destroy()
        }
    }
}

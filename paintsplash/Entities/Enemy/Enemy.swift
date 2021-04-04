//
//  Enemy.swift
//  paintsplash
//
//  Created by Cynthia Lee on 11/3/21.
//

import SpriteKit

let hitDuration: Double = 0.25

class Enemy: GameEntity, StatefulEntity, Renderable, Animatable, Collidable, Movable, Colorable, Health {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent
    var collisionComponent: CollisionComponent
    var moveableComponent: MoveableComponent
    var healthComponent: HealthComponent
    var stateComponent: StateComponent
    var animationComponent: AnimationComponent

    var color: PaintColor
    private let moveSpeed = 1.0

    var lastDirection = Vector2D.zero

    init(initialPosition: Vector2D, color: PaintColor) {
        self.color = color

        self.renderComponent = RenderComponent(
            renderType: .sprite(spriteName: "Slime"),
            zPosition: Constants.ZPOSITION_PLAYER
        )

        self.transformComponent = TransformComponent(
            position: initialPosition,
            rotation: 0,
            size: Constants.ENEMY_SIZE
        )

        let healthComp = EnemyHealthComponent(
            currentHealth: 1,
            maxHealth: 1
        )

        self.healthComponent = healthComp

        let collisionComp = EnemyCollisionComponent(
            colliderShape: .circle(radius: 50),
            tags: [.enemy]
        )
        self.collisionComponent = collisionComp

        self.moveableComponent = MoveableComponent(
            direction: Vector2D.zero,
            speed: moveSpeed
        )

        self.stateComponent = StateComponent()

        self.animationComponent = AnimationComponent()

        super.init()

        self.stateComponent.currentState = EnemyState.Idle(enemy: self)

        // Assign weak references to components
        collisionComp.enemy = self
        healthComp.enemy = self
    }

    // TODO: figure out if and why this isn't being called
    deinit {
        print("removed enemy")
    }
}

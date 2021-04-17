//
//  Enemy.swift
//  paintsplash
//
//  Created by Cynthia Lee on 11/3/21.
//

import SpriteKit

class Enemy: GameEntity, StatefulEntity, Renderable, Animatable, Collidable, Movable, Colorable, Health {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent
    var collisionComponent: CollisionComponent
    var moveableComponent: MoveableComponent
    var healthComponent: HealthComponent
    var stateComponent: StateComponent
    var animationComponent: AnimationComponent

    var color: PaintColor
    private let moveSpeed = Constants.ENEMY_MOVE_SPEED

    var lastDirection = Vector2D.zero

    init(initialPosition: Vector2D, color: PaintColor, health: Int = Constants.ENEMY_HEALTH,
         size: Vector2D = Constants.ENEMY_SIZE, radius: Double = Constants.ENEMY_RADIUS) {
        self.color = color

        self.renderComponent = RenderComponent(
            renderType: .sprite(spriteName: "Slime"),
            zPosition: Constants.ZPOSITION_PLAYER
        )

        self.transformComponent = TransformComponent(
            position: initialPosition,
            rotation: 0,
            size: size
        )

        let healthComp = EnemyHealthComponent(
            currentHealth: health,
            maxHealth: health
        )

        self.healthComponent = healthComp

        let collisionComp = EnemyCollisionComponent(
            colliderShape: .circle(radius: radius),
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

        // 50% chance of entering random movement state, or chasing player state
        let isChasing = Bool.random()
        if isChasing {
            self.stateComponent.setState(EnemyState.ChasingLeft(enemy: self))
        } else {
            self.stateComponent.setState(EnemyState.Idle(enemy: self))
        }

        // Assign weak references to components
        collisionComp.enemy = self
        healthComp.enemy = self
    }

    deinit {
        print("removed enemy")
    }
}

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
            size: Vector2D(100, 100)
        )

        self.healthComponent = HealthComponent(currentHealth: 1, maxHealth: 1)
        self.collisionComponent = CollisionComponent(
            colliderShape: .circle(radius: 50),
            tags: [.enemy]
        )

        self.moveableComponent = MoveableComponent(direction: Vector2D.zero, speed: moveSpeed)
        self.stateComponent = StateComponent()
        self.animationComponent = AnimationComponent()

        super.init()

        self.stateComponent.currentState = EnemyState.Idle(enemy: self)
    }

    func onCollide(with: Collidable) {
        if with.collisionComponent.tags.contains(.playerProjectile) {
            switch with {
            case let projectile as PaintProjectile:
                if projectile.color.contains(color: self.color) || projectile.color == PaintColor.white {
                    takeDamage(amount: 1)
                }
            default:
                fatalError("Projectile not conforming to projectile protocol")
            }
        }

        if with.collisionComponent.tags.contains(.player) {
            takeDamage(amount: 1)
        }
    }

    func heal(amount: Int) {
        healthComponent.currentHealth += amount
    }

    func takeDamage(amount: Int) {
        healthComponent.currentHealth -= amount

        if healthComponent.currentHealth <= 0 {
            die()
            return
        }

        animationComponent.animate(animation: SlimeAnimations.slimeHitGray, interupt: true)
    }

    private func die() {
        moveableComponent.speed = 0
        collisionComponent.active = false
//        animationComponent.animate(animation: SlimeAnimations.slimeDieGray, interupt: true,
//                                   callBack: { self.destroy() })
        stateComponent.currentState = EnemyState.Die(enemy: self)

        EventSystem.scoreEvent.post(event: ScoreEvent(value: Points.enemyKill))
    }

    // TODO: figure out if and why this isn't being called
    deinit {
        print("removed enemy")
    }
}

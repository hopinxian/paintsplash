//
//  EnemySpawner.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/3/21.
//

class EnemySpawner: GameEntity, StatefulEntity, Transformable, Renderable, Animatable, Collidable, Colorable, Health {
    var stateComponent: StateComponent
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent
    var collisionComponent: CollisionComponent
    var healthComponent: HealthComponent
    var animationComponent: AnimationComponent

    var color: PaintColor

    init(initialPosition: Vector2D, color: PaintColor) {

        self.renderComponent = RenderComponent(
            renderType: .sprite(spriteName: "Spawner"),
            zPosition: Constants.ZPOSITION_PLAYER
        )

        self.transformComponent = TransformComponent(
            position: initialPosition,
            rotation: 0,
            size: Vector2D(100, 100)
        )

        self.healthComponent = HealthComponent(currentHealth: 3, maxHealth: 3)
        self.collisionComponent = CollisionComponent(colliderShape: .circle(radius: 50), tags: [])
        self.stateComponent = StateComponent()
        self.animationComponent = AnimationComponent()

        self.color = color

        super.init()

        self.stateComponent.currentState = EnemySpawnerState.Idle(spawner: self, idleTime: 100)
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
    }

    private func die() {
        let event = RemoveEntityEvent(entity: self)
        EventSystem.entityChangeEvents.removeEntityEvent.post(event: event)
    }
}

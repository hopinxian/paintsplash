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
            size: Constants.ENEMY_SPAWNER_SIZE
        )

        let healthComp = EnemySpawnerHealthComponent(
            currentHealth: 3,
            maxHealth: 3
        )

        self.healthComponent = healthComp

        let collisionComp = EnemySpawnerCollisionComponent(
            colliderShape: .circle(radius: 50),
            tags: []
        )

        self.collisionComponent = collisionComp

        self.stateComponent = StateComponent()

        self.animationComponent = AnimationComponent()

        self.color = color

        super.init()

        self.stateComponent.currentState = EnemySpawnerState.Idle(
            spawner: self,
            idleTime: 100
        )

        // Assign weak references to components
        collisionComp.spawner = self
        healthComp.spawner = self
    }
}

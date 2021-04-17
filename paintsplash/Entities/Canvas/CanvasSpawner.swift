//
//  CanvasSpawner.swift
//  paintsplash
//
//  Created by Cynthia Lee on 16/3/21.
//

class CanvasSpawner: GameEntity, StatefulEntity, Transformable {
    var transformComponent: TransformComponent
    let stateComponent: StateComponent
    private var spawnInterval: Double

    init(initialPosition: Vector2D = Constants.CANVAS_SPAWNER_POSITION,
         canvasVelocity: Vector2D = Constants.CANVAS_SPAWNER_VELOCITY,
         spawnInterval: Double = Constants.CANVAS_SPAWNER_SPAWN_INTERVAL) {
        self.spawnInterval = spawnInterval
        self.transformComponent = TransformComponent(
            position: initialPosition,
            rotation: 0,
            size: Constants.CANVAS_SPAWNER_SIZE
        )

        self.stateComponent = StateComponent()

        super.init()

        self.stateComponent.currentState =
            CanvasSpawnerState.Idle(spawner: self, idleTime: 1)
    }
}

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

    init(initialPosition: Vector2D, canvasVelocity: Vector2D, spawnInterval: Double) {
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

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

    init(canvasVelocity: Vector2D,
         spawnInterval: Double,
         initialPosition: Vector2D = Constants.CANVAS_SPAWNER_POSITION) {
        self.spawnInterval = spawnInterval
        self.transformComponent = TransformComponent(
            position: initialPosition,
            rotation: 0,
            size: Constants.CANVAS_SPAWNER_SIZE
        )

        self.stateComponent = StateComponent()

        super.init()

        self.stateComponent.setState(CanvasSpawnerState.Idle(spawner: self, idleTime: 1))
    }
}

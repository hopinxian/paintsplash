//
//  CanvasSpawner.swift
//  paintsplash
//
//  Created by Cynthia Lee on 16/3/21.
//

class CanvasSpawner: GameEntity, AIEntity, Transformable {
    let transformComponent: TransformComponent
    let aiComponent: AIComponent
    // X-coordinate where canvas should disappear
    private var spawnInterval: Double

    init(initialPosition: Vector2D, canvasVelocity: Vector2D, spawnInterval: Double) {
        self.spawnInterval = spawnInterval
        self.transformComponent = TransformComponent(position: initialPosition, rotation: 0, size: Constants.CANVAS_SPAWNER_SIZE)
        self.aiComponent = AIComponent(defaultState: CanvasSpawnerState.Idle(idleTime: 1))

        super.init()

        addComponent(transformComponent)
        addComponent(aiComponent)
    }
}

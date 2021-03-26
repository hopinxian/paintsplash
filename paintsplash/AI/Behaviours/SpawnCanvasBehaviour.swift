//
//  SpawnCanvasBehaviour.swift
//  paintsplash
//
//  Created by Cynthia Lee on 17/3/21.
//
import Foundation

class SpawnCanvasBehaviour: StateBehaviour {
    private var complete = false

    func updateAI(aiEntity: StatefulEntity, aiGameInfo: AIGameInfo) {
        guard !complete,
              let transformable = aiEntity as? Transformable else {
            fatalError("AIEntity does not conform to the required protocols for SpawnEnemyBehaviour")
        }

        let spawnPosition = transformable.transformComponent.position

        let canvas = Canvas(
            initialPosition: spawnPosition,
            direction: Vector2D(1, 0),
            size: Constants.CANVAS_SPAWNER_SIZE
        )
        canvas.spawn()

        complete = true
    }
}

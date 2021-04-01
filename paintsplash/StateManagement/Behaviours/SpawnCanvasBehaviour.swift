//
//  SpawnCanvasBehaviour.swift
//  paintsplash
//
//  Created by Cynthia Lee on 17/3/21.
//
import Foundation

class SpawnCanvasBehaviour: StateBehaviour {
    func updateAI(aiEntity: StatefulEntity, aiGameInfo: GameInfo) {
        guard let transformable = aiEntity as? Transformable else {
            fatalError("AIEntity does not conform to the required protocols for SpawnEnemyBehaviour")
        }

        let spawnPosition = transformable.transformComponent.localPosition

        let canvas = Canvas(
            initialPosition: spawnPosition,
            direction: Vector2D(1, 0),
            size: Constants.CANVAS_SPAWNER_SIZE,
            endX: Constants.CANVAS_END_MARKER_POSITION.x
        )
        canvas.spawn()
    }
}

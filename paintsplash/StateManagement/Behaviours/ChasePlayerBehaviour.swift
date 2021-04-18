//
//  ApproachPointBehaviour.swift
//  paintsplash
//
//  Created by Cynthia Lee on 11/3/21.
//

import CoreGraphics

/// Move towards the player's location
struct ChasePlayerBehaviour: StateBehaviour {
    func run(statefulEntity: StatefulEntity, gameInfo: GameInfo) {
        guard let movable = statefulEntity as? Movable else {
            fatalError(
                "AIEntity does not conform to the required protocols for ChasePlayerBehaviour"
            )
        }

        let enemyCurrentPosition = movable.transformComponent.localPosition
        let playerPosition = gameInfo.playerPosition
        let direction = playerPosition - enemyCurrentPosition

        var newDirection = direction.unitVector

        if direction.magnitude < 0.5 {
            newDirection = Vector2D.zero
        }

        movable.moveableComponent.direction = newDirection
    }
}

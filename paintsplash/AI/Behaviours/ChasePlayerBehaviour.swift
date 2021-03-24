//
//  ApproachPointBehaviour.swift
//  paintsplash
//
//  Created by Cynthia Lee on 11/3/21.
//

import CoreGraphics

struct ChasePlayerBehaviour: AIBehaviour {
    func updateAI(aiEntity: AIEntity, aiGameInfo: AIGameInfo) {
        // move towards player location
        guard let movable = aiEntity as? Movable else {
            fatalError("AIEntity does not conform to the required protocols for ApproachPointBehaviour")
        }

        let enemyCurrentPosition = movable.transformComponent.position
        let playerPosition = aiGameInfo.playerPosition

        let direction = playerPosition - enemyCurrentPosition

        var newDirection = direction.unitVector

        if direction.magnitude < 0.5 {
            newDirection = Vector2D.zero
        }

        movable.moveableComponent.direction = newDirection
    }
}

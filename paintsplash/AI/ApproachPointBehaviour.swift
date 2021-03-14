//
//  ApproachPointBehaviour.swift
//  paintsplash
//
//  Created by Cynthia Lee on 11/3/21.
//

import CoreGraphics

struct ApproachPointBehaviour: AIBehaviour {
    func updateAI(aiEntity: AIEntity, aiGameInfo: AIGameInfo) {
        // move towards player location
        let enemyCurrentPosition = aiEntity.position
        let playerPosition = aiGameInfo.playerPosition

        var newVelocity = playerPosition - enemyCurrentPosition

        guard Vector2D.magnitude(of: newVelocity) > 1 else {
            return
        }

        // TODO: change speed based on velocity, change velocity based on speed?
        let currentSpeed = aiEntity.velocity.magnitude
        let newSpeed = newVelocity.magnitude

        if newSpeed == 0 {
            print("new speed == 0")
        } else {
            let scaleFactor = currentSpeed / newSpeed
            newVelocity *= scaleFactor
        }

        aiEntity.velocity = newVelocity
        aiEntity.move()
    }
}

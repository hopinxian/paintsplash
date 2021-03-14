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

        // TODO: change speed based on velocity, change velocity based on speed?
        let newSpeed = newVelocity.magnitude
        
        if newSpeed >= 0.5 {
            let scaleFactor = aiEntity.defaultSpeed / newSpeed
            newVelocity *= scaleFactor
        }

        aiEntity.velocity = newVelocity
        aiEntity.move()
    }
}

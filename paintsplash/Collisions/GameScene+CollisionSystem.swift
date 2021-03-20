//
//  GameScene+CollisionSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import SpriteKit

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        gameManager.collisionSystem.detectCollision(contact)
    }
}

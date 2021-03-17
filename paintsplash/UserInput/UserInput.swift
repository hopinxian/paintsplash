//
//  UserInput.swift
//  paintsplash
//
//  Created by Farrell Nah on 9/3/21.
//

import Foundation
import CoreGraphics

protocol UserInput {
    func touchDown(atPoint pos : CGPoint)

    func touchMoved(toPoint pos : CGPoint)

    func touchUp(atPoint pos : CGPoint)
}

protocol InputSystem {

}

class Player: InteractiveEntity, Movable {

    var velocity: Vector2D
    var acceleration: Vector2D
    var defaultSpeed: Double = 1.0

    init(initialPosition: Vector2D, initialVelocity: Vector2D) {
        self.velocity = Vector2D.zero
        self.acceleration = Vector2D.zero

        var transform = Transform.identity
        transform.position = initialPosition

        super.init(spriteName: "", colliderShape: .circle(radius: 50), tags: .player, transform: transform)

        self.currentAnimation = SlimeAnimations.slimeMoveRightGray

        EventSystem.processedInputEvent.subscribe(listener: onReceiveInput)
    }

    override func update(gameManager: GameManager) {
        move()
        super.update(gameManager: gameManager)
    }

    func onReceiveInput(event: ProcessedInputEvent) {
        switch event.processedInputType {
        case .playerMovement(let direction):
            velocity = direction
        default:
            break
        }
    }
}

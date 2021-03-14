//
//  AIEntity.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//

class AIEntity: InteractiveEntity, Movable {
    var velocity: Vector2D

    var acceleration: Vector2D

    var defaultSpeed: Double = 0.0

    var currentBehaviour: AIBehaviour = ApproachPointBehaviour()

    var state: AIEntityState = .idle

    init(initialPosition: Vector2D, initialVelocity: Vector2D, radius: Double) {
        self.velocity = initialVelocity
        self.acceleration = Vector2D.zero

        var transform = Transform.identity
        transform.position = initialPosition

        super.init(spriteName: "", colliderShape: .circle(radius: radius), tags: .enemy, transform: transform)
    }

    func changeBehaviour(to behaviour: AIBehaviour) {
        self.currentBehaviour = behaviour
    }

    func updateAI(aiGameInfo: AIGameInfo) {
        currentBehaviour.updateAI(aiEntity: self, aiGameInfo: aiGameInfo)
    }
}

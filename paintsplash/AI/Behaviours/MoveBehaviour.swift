//
//  CanvasBehaviour.swift
//  paintsplash
//
//  Created by Cynthia Lee on 16/3/21.
//

struct MoveBehaviour: AIBehaviour {
    let velocity: Vector2D
    let speed: Double

    init(velocity: Vector2D, speed: Double) {
        self.velocity = velocity
        self.speed = speed
    }

    func updateAI(aiEntity: AIEntity, aiGameInfo: AIGameInfo) {
        guard let movable = aiEntity as? Movable else {
            fatalError("AIEntity does not conform to the required protocols for CanvasBehaviour")
        }

        movable.moveableComponent.direction = Vector2D.normalize(velocity) * speed
    }
}

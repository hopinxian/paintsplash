//
//  CanvasBehaviour.swift
//  paintsplash
//
//  Created by Cynthia Lee on 16/3/21.
//

struct MoveBehaviour: StateBehaviour {
    let direction: Vector2D
    let speed: Double

    init(direction: Vector2D, speed: Double) {
        self.direction = direction
        self.speed = speed
    }

    func updateAI(aiEntity: StatefulEntity, aiGameInfo: GameInfo) {
        guard let movable = aiEntity as? Movable else {
            fatalError("AIEntity does not conform to the required protocols for CanvasBehaviour")
        }

        let moveableComponent = movable.moveableComponent
        moveableComponent.direction = direction
        moveableComponent.speed = speed
    }
}

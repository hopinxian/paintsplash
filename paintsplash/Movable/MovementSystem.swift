//
//  MovementSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 23/3/21.
//

protocol MovementSystem: System {

}

class FrameMovementSystem: MovementSystem {
    func updateEntity(_ entity: GameEntity) {
        guard let movable = entity as? Movable else {
            return
        }

        let transformComponent = movable.transformComponent
        let movementComponent = movable.moveableComponent

        transformComponent.position += movementComponent.direction * movementComponent.speed
    }
}

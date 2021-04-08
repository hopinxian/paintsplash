//
//  FrameMovementSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class FrameMovementSystem: MovementSystem {
    var moveables = [GameEntity: Movable]()
    func addEntity(_ entity: GameEntity) {
        guard let moveable = entity as? Movable else {
            return
        }

        moveables[entity] = moveable
    }

    func removeEntity(_ entity: GameEntity) {
        moveables[entity] = nil
    }

    func updateEntity(_ entity: GameEntity, _ movable: Movable, _ deltaTime: Double) {
        let transformComponent = movable.transformComponent
        let movementComponent = movable.moveableComponent

        transformComponent.localPosition += movementComponent.direction * movementComponent.speed * deltaTime
    }

    func updateEntities(_ deltaTime: Double) {
        for (entity, moveable) in moveables {
            updateEntity(entity, moveable, deltaTime)
        }
    }
}

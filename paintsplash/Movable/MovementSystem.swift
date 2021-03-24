//
//  MovementSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 23/3/21.
//

protocol MovementSystem: System {
    var moveables: [GameEntity: Movable] { get set }
}

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

    func updateEntity(_ entity: GameEntity, _ movable: Movable) {
        let transformComponent = movable.transformComponent
        let movementComponent = movable.moveableComponent

        transformComponent.position += movementComponent.direction * movementComponent.speed
    }

    func updateEntities() {
        for (entity, moveable) in moveables {
            updateEntity(entity, moveable)
        }
    }
}

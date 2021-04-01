//
//  NetworkAnimationSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 31/3/21.
//

class NetworkAnimationSystem: AnimationSystem {
    var animatables = [EntityID: Animatable]()

    init() {
    }

    func addEntity(_ entity: GameEntity) {
        guard let animatable = entity as? Animatable else {
            return
        }

        animatables[entity.id] = animatable
    }

    func removeEntity(_ entity: GameEntity) {
        animatables[entity.id] = nil
    }

    func updateEntities() {
        for (entity, animatable) in animatables {
            updateEntity(entity, animatable)
        }
    }

    func updateEntity(_ entity: EntityID, _ animatable: Animatable) {
        let animationComponent = animatable.animationComponent

        guard let animationToPlay = animationComponent.animationToPlay else {
            return
        }

        animationComponent.animationIsPlaying = true
        animationComponent.currentAnimation = animationToPlay
        animationComponent.animationToPlay = nil
    }
}

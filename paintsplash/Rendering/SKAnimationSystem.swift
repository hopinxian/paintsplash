//
//  SKAnimationSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class SKAnimationSystem: AnimationSystem {
    var animatables = [GameEntity: Animatable]()
    let renderSystem: SKRenderSystem

    init(renderSystem: SKRenderSystem) {
        self.renderSystem = renderSystem
    }

    func addEntity(_ entity: GameEntity) {
        guard let animatable = entity as? Animatable else {
            return
        }

        animatables[entity] = animatable
    }

    func removeEntity(_ entity: GameEntity) {
        animatables[entity] = nil
    }

    func updateEntities() {
        for (entity, animatable) in animatables {
            updateEntity(entity, animatable)
        }
    }

    func updateEntity(_ entity: GameEntity, _ animatable: Animatable) {
        let animationComponent = animatable.animationComponent

        guard let node = renderSystem.getNodeEntityMap()[entity],
              let animationToPlay = animationComponent.animationToPlay else {
            return
        }

        node.removeAllActions()
        node.run(animationToPlay.getAction(), withKey: animationToPlay.name)

        animationComponent.animationIsPlaying = true
        animationComponent.currentAnimation = animationToPlay
        animationComponent.animationToPlay = nil
    }
}

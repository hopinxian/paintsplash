//
//  SKAnimationSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//
import SpriteKit

class SKAnimationSystem: AnimationSystem {
    var animatables = [EntityID: Animatable]()
    let renderSystem: SKRenderSystem

    init(renderSystem: SKRenderSystem) {
        self.renderSystem = renderSystem
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

        guard let node = renderSystem.getNodeEntityMap()[entity],
              let animationToPlay = animationComponent.animationToPlay else {
            return
        }

        node.removeAllActions()
        let animation = AnimationManager.getAnimation(from: animationToPlay)
        let actionToRun = SKAction.sequence([animation.getAction(), SKAction.run({
            animationComponent.callBack?()
            animationComponent.animationIsPlaying = false
        })])
        node.run(actionToRun, withKey: animation.name)

        animationComponent.animationIsPlaying = true
        animationComponent.currentAnimation = animationToPlay
        animationComponent.animationToPlay = nil
    }
}

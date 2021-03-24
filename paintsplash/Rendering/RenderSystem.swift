//
//  RenderableSystem.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

import SpriteKit

protocol RenderSystem: System {
    func addEntity(_ entity: GameEntity)
    func removeEntity(_ entity: GameEntity)
}

class SKRenderSystem: RenderSystem {
    private let scene: GameScene
    private var nodeEntityMap = BidirectionalMap<GameEntity, SKNode>()

    init(scene: GameScene) {
        self.scene = scene
    }

    func addEntity(_ entity: GameEntity) {
        var node = SKNode()
        if let renderable = entity as? Renderable {
            node = buildNode(for: renderable)
        }

        scene.addChild(node)
        nodeEntityMap[entity] = node
    }

    func removeEntity(_ entity: GameEntity) {
        guard let node = nodeEntityMap[entity] else {
            return
        }

        node.removeFromParent()
        nodeEntityMap[entity] = nil
    }

    func updateEntity(_ entity: GameEntity) {
        guard let renderable = entity as? Renderable,
              let node = nodeEntityMap[entity] else {
            return
        }

        let transformComponent = renderable.transformComponent
        node.position = SpaceConverter.modelToScreen(transformComponent.position)
        node.zRotation = CGFloat(transformComponent.rotation)
    }

    func buildNode(for renderable: Renderable) -> SKNode {
        SKNodeFactory.getSKNode(from: renderable)
    }

    func getNodeEntityMap() -> BidirectionalMap<GameEntity, SKNode> {
        nodeEntityMap
    }

}

protocol AnimationSystem: System {

}

class SKAnimationSystem: AnimationSystem {
    let renderSystem: SKRenderSystem

    init(renderSystem: SKRenderSystem) {
        self.renderSystem = renderSystem
    }

    func updateEntity(_ entity: GameEntity) {
        guard let animatable = entity as? Animatable else {
            return
        }

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

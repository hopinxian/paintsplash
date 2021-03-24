//
//  RenderableSystem.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

import SpriteKit

protocol RenderSystem: System {
    var renderables: [GameEntity: Renderable] { get set }
    func updateEntity(_ entity: GameEntity, _ renderable: Renderable)
}

class SKRenderSystem: RenderSystem {
    var renderables = [GameEntity : Renderable]()
    private let scene: GameScene
    private var nodeEntityMap = BidirectionalMap<GameEntity, SKNode>()

    init(scene: GameScene) {
        self.scene = scene
    }

    func addEntity(_ entity: GameEntity) {
        var node = SKNode()
        if let renderable = entity as? Renderable {
            node = buildNode(for: renderable)
            renderables[entity] = renderable
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
        renderables[entity] = nil
    }

    private func buildNode(for renderable: Renderable) -> SKNode {
        SKNodeFactory.getSKNode(from: renderable)
    }

    func getNodeEntityMap() -> BidirectionalMap<GameEntity, SKNode> {
        nodeEntityMap
    }

    func updateEntities() {
        for (entity, renderable) in renderables {
            updateEntity(entity, renderable)
        }
    }

    func updateEntity(_ entity: GameEntity, _ renderable: Renderable) {
        guard let node = nodeEntityMap[entity] else {
            return
        }

        let transformComponent = renderable.transformComponent
        node.position = SpaceConverter.modelToScreen(transformComponent.position)
        node.zRotation = CGFloat(transformComponent.rotation)
    }

}

protocol AnimationSystem: System {
    var animatables: [GameEntity: Animatable] { get set }
}

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

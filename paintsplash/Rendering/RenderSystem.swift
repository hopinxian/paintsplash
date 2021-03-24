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
    var renderables = [GameEntity: Renderable]()
    private let scene: GameScene
    private var nodeEntityMap = BidirectionalMap<GameEntity, SKNode>()

    init(scene: GameScene) {
        self.scene = scene

        EventSystem.changeViewEvent.subscribe(listener: onChangeView)
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

    func addSubviewToEntity(_ entity: GameEntity, subviewInfo: RenderInfo) {
        guard let node = nodeEntityMap[entity] else {
            return
        }

        let subview = SKSpriteNode(imageNamed: subviewInfo.spriteName)

        subview.position = SpaceConverter.modelToScreen(subviewInfo.position)
        subview.size = SpaceConverter.modelToScreen(Vector2D(subviewInfo.width, subviewInfo.height))
        subview.zPosition = CGFloat(node.zPosition + 1)
        subview.color = subviewInfo.color.uiColor
        subview.colorBlendFactor = CGFloat(subviewInfo.colorBlend)
        subview.zRotation = CGFloat(subviewInfo.rotation)

        if subviewInfo.cropInParent {
            let cropNode = SKCropNode()

            let maskNode = node.copy() as? SKSpriteNode
            maskNode?.position = .zero

            cropNode.maskNode = maskNode
            cropNode.position = .zero
            cropNode.zPosition = CGFloat(node.zPosition + 1)
            cropNode.addChild(subview)

            node.addChild(cropNode)
        } else {
            node.addChild(subview)
        }

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

    func onChangeView(event: ChangeViewEvent) {
        switch event {
        case let addSubviewEvent as AddSubviewEvent:
            addSubviewToEntity(addSubviewEvent.renderable,
                               subviewInfo: addSubviewEvent.subviewRenderInfo)
        default:
            break
        }
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

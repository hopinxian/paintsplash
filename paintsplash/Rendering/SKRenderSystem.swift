//
//  SKRenderSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//
import SpriteKit

class SKRenderSystem: RenderSystem {
    var renderables = [GameEntity: Renderable]()
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

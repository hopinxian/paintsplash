//
//  SKRenderSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//
import SpriteKit

class SKRenderSystem: RenderSystem {
    var renderables = [EntityID: Renderable]()
    private weak var scene: GameScene?
    private var nodeEntityMap = BidirectionalMap<EntityID, SKNode>()

    init(scene: GameScene) {
        self.scene = scene
    }

    func addEntity(_ entity: GameEntity) {
        var node = SKNode()
        if let renderable = entity as? Renderable {
            node = addAsRenderable(entity: entity, renderable: renderable)
        } else {
            node = addAsNonRenderable()
        }

        if node.parent == nil {
            scene?.addChild(node)
        }

        nodeEntityMap[entity.id] = node
    }

    private func addAsRenderable(entity: GameEntity, renderable: Renderable) -> SKNode {
        let node = buildNode(for: renderable)
        renderables[entity.id] = renderable

        if let parent = renderable.transformComponent.parentID,
           let parentNode = nodeEntityMap[parent] {
            addChildToNode(parentNode: parentNode, childNode: node)
        }

        return node
    }

    private func addAsNonRenderable() -> SKNode {
        SKNode()
    }

    private func addChildToNode(parentNode: SKNode, childNode: SKNode) {
        let cropNode = SKCropNode()

        let maskNode = parentNode.copy() as? SKSpriteNode
        maskNode?.position = .zero

        cropNode.maskNode = maskNode
        cropNode.position = .zero
        cropNode.zPosition = CGFloat(childNode.zPosition + 1)
        cropNode.addChild(childNode)

        parentNode.addChild(cropNode)
    }

    func removeEntity(_ entity: GameEntity) {
        guard let node = nodeEntityMap[entity.id] else {
            return
        }

        node.removeFromParent()
        nodeEntityMap[entity.id] = nil
        renderables[entity.id] = nil
    }

    private func buildNode(for renderable: Renderable) -> SKNode {
        SKNodeFactory.getSKNode(from: renderable)
    }

    func getNodeEntityMap() -> BidirectionalMap<EntityID, SKNode> {
        nodeEntityMap
    }

    func updateEntities() {
        for (entity, renderable) in renderables {
            updateEntity(entity, renderable)
        }
    }

    func updateEntity(_ entity: EntityID, _ renderable: Renderable) {
        guard let node = nodeEntityMap[entity] else {
            return
        }

        let transformComponent = renderable.transformComponent
        node.position = SpaceConverter.modelToScreen(transformComponent.localPosition)
        node.zRotation = CGFloat(transformComponent.rotation)

        updateSpecificNodeTypes(node, renderable)
    }

    private func updateSpecificNodeTypes(_ node: SKNode, _ renderable: Renderable) {
        switch renderable.renderComponent.renderType {
        case .sprite(_):
            if let spriteNode = node as? SKSpriteNode {
                updateSpriteNode(spriteNode, renderable)
            }
        case .label(let text):
            if let labelNode = node as? SKLabelNode {
                updateLabelNode(labelNode, text: text)
            }
        }
    }

    private func updateSpriteNode(_ node: SKSpriteNode, _ renderable: Renderable) {
        if let colorData = renderable as? Colorable {
            if node.color != colorData.color.uiColor {
                node.color = colorData.color.uiColor
            }
        }
        let screenSize: CGSize = SpaceConverter.modelToScreen(renderable.transformComponent.size)
        if node.size != screenSize {
            node.size = screenSize
        }
    }

    private func updateLabelNode(_ node: SKLabelNode, text: String) {
        if node.text != text {
            node.text = text
        }
    }

    func renderableFromNode(_ node: SKNode) -> Renderable? {
        guard let id = nodeEntityMap[node] else {
            return nil
        }
        return renderables[id]
    }
}

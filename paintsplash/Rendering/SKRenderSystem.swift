//
//  SKRenderSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//
import SpriteKit

class SKRenderSystem: RenderSystem {
    var renderables = [EntityID: Renderable]()
    var wasModified = [EntityID: Renderable]()
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
        wasModified[entity.id] = renderable

        return node
    }

    private func addAsNonRenderable() -> SKNode {
        SKNode()
    }

    private func getCroppedToNode(maskNode: SKNode, childNode: SKNode) -> SKNode? {
        guard let mask = maskNode.copy() as? SKSpriteNode else {
            return nil
        }
        let parentPos = maskNode.position
        let childPos = childNode.position

        let parentNode = SKNode()
        parentNode.position = childNode.position

        let cropNode = SKCropNode()

        mask.position = .zero

        cropNode.maskNode = mask
        cropNode.zPosition = CGFloat(childNode.zPosition + 1)
        cropNode.position = maskNode.position

        childNode.position =
            CGPoint(x: childPos.x - parentPos.x, y: childPos.y - parentPos.y)
        cropNode.addChild(childNode)

        cropNode.position =
            CGPoint(x: parentPos.x - childPos.x, y: parentPos.y - childPos.y)
        parentNode.addChild(cropNode)

        return parentNode
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
        var node = SKNodeFactory.getSKNode(from: renderable)

        if let parent = renderable.transformComponent.parentID,
           let parentNode = nodeEntityMap[parent],
           renderable.renderComponent.cropInParent,
           let cropNode = getCroppedToNode(maskNode: parentNode, childNode: node) {
            node = cropNode
        }

        return node
    }

    func getNodeEntityMap() -> BidirectionalMap<EntityID, SKNode> {
        nodeEntityMap
    }

    func updateEntities() {
        wasModified = [:]
        for (entity, renderable) in renderables {
            updateEntity(entity, renderable)
        }
    }

    func updateEntity(_ entity: EntityID, _ renderable: Renderable) {
        let transformComponent = renderable.transformComponent
        let renderComponent = renderable.renderComponent

        guard transformComponent.wasModified || renderComponent.wasModified,
              let node = nodeEntityMap[entity] else {
            return
        }

        wasModified[entity] = renderable
        transformComponent.wasModified = false
        renderComponent.wasModified = false

        let newPosition: CGPoint =
            SpaceConverter.modelToScreen(transformComponent.worldPosition)
        node.position = newPosition

        let newRotation = CGFloat(transformComponent.rotation)
        node.zRotation = newRotation

        updateSpecificNodeTypes(node, renderable)
    }

    private func updateSpecificNodeTypes(_ node: SKNode, _ renderable: Renderable) {
        switch renderable.renderComponent.renderType {
        case .sprite:
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
        if let colorData = renderable as? Colorable,
           node.color != colorData.color.uiColor {
            node.color = colorData.color.uiColor
            node.children
                .compactMap({ $0 as? SKSpriteNode })
                .forEach({ $0.color = colorData.color.uiColor })
        }

        let screenSize: CGSize = SpaceConverter.modelToScreen(renderable.transformComponent.size)

        node.size = screenSize
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

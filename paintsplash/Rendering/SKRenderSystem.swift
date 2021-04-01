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

        return node
    }

    private func addAsNonRenderable() -> SKNode {
        SKNode()
    }

    private func getCroppedToNode(maskNode: SKNode, childNode: SKNode) -> SKCropNode? {
        guard let mask = maskNode.copy() as? SKSpriteNode else {
            return nil
        }
        let cropNode = SKCropNode()

        mask.position = .zero

        cropNode.maskNode = mask
        cropNode.position = maskNode.position
        cropNode.zPosition = CGFloat(childNode.zPosition + 1)
        cropNode.addChild(childNode)

        return cropNode
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
            renderable.transformComponent.localPosition = .zero
        }

        return node
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
        node.position = SpaceConverter.modelToScreen(transformComponent.worldPosition)
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
                node.children.compactMap({ $0 as? SKSpriteNode }).forEach({ $0.color = colorData.color.uiColor })
                print(colorData.color)
                print(node.children)
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

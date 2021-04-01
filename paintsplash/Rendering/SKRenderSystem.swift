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

//        EventSystem.changeViewEvent.subscribe(listener: onChangeView)
    }

    func addEntity(_ entity: GameEntity) {
        var node = SKNode()
        if let renderable = entity as? Renderable {
            node = buildNode(for: renderable)
            renderables[entity.id] = renderable
            if let parent = renderable.transformComponent.parentID {
                if let parentNode = nodeEntityMap[parent] {
                    let cropNode = SKCropNode()

                    let maskNode = parentNode.copy() as? SKSpriteNode
                    maskNode?.position = .zero

                    cropNode.maskNode = maskNode
                    cropNode.position = .zero
                    cropNode.zPosition = CGFloat(node.zPosition + 1)
                    cropNode.addChild(node)

                    parentNode.addChild(cropNode)
                }
            } else {
                scene?.addChild(node)
            }
        } else {
            scene?.addChild(node)
        }

        nodeEntityMap[entity.id] = node

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
        // Only update those without parents. Those with parents will be updated automatically
        guard let node = nodeEntityMap[entity],
              renderable.transformComponent.parentID == nil else {
            return
        }

        let transformComponent = renderable.transformComponent
        node.position = SpaceConverter.modelToScreen(transformComponent.worldPosition)
        node.zRotation = CGFloat(transformComponent.rotation)
        print(renderable)
        print(node.position)

        switch renderable.renderComponent.renderType {
        case .sprite(let spriteName):
            if let spriteNode = node as? SKSpriteNode {
                if let colorData = renderable as? Colorable {
                    if spriteNode.color != colorData.color.uiColor {
                        spriteNode.color = colorData.color.uiColor
                    }
                }
                let screenSize: CGSize = SpaceConverter.modelToScreen(renderable.transformComponent.size)
                if spriteNode.size != screenSize {
                    spriteNode.size = screenSize
                }
            }
        case .label(let text):
            if let labelNode = node as? SKLabelNode,
               labelNode.text != text {
                labelNode.text = text
            }
        }
    }

//    func onChangeView(event: ChangeViewEvent) {
//        switch event {
//        case let addSubviewEvent as AddSubviewEvent:
//            addSubviewToEntity(addSubviewEvent.renderable,
//                               subviewInfo: addSubviewEvent.subviewRenderInfo)
//        default:
//            break
//        }
//    }
//
//    func addSubviewToEntity(_ entity: GameEntity, subviewInfo: RenderInfo) {
//        guard let node = nodeEntityMap[entity.id] else {
//            return
//        }
//
//        let subview = SKSpriteNode(imageNamed: subviewInfo.spriteName)
//
//        subview.position = SpaceConverter.modelToScreen(subviewInfo.position)
//        subview.size = SpaceConverter.modelToScreen(Vector2D(subviewInfo.width, subviewInfo.height))
//        subview.zPosition = CGFloat(node.zPosition + 1)
//        subview.color = subviewInfo.color.uiColor
//        subview.colorBlendFactor = CGFloat(subviewInfo.colorBlend)
//        subview.zRotation = CGFloat(subviewInfo.rotation)
//
//        if subviewInfo.cropInParent {
//            let cropNode = SKCropNode()
//
//            let maskNode = node.copy() as? SKSpriteNode
//            maskNode?.position = .zero
//
//            cropNode.maskNode = maskNode
//            cropNode.position = .zero
//            cropNode.zPosition = CGFloat(node.zPosition + 1)
//            cropNode.addChild(subview)
//
//            node.addChild(cropNode)
//        } else {
//            node.addChild(subview)
//        }
//    }

}

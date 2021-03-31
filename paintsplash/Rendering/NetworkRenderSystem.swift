//
//  NetworkRenderSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 31/3/21.
//

class NetworkRenderSystem: RenderSystem {
    var renderables = [GameEntity: Renderable]()

    init() {
//        EventSystem.changeViewEvent.subscribe(listener: onChangeView)
    }

    func addEntity(_ entity: GameEntity) {
        if let renderable = entity as? Renderable {
            renderables[entity] = renderable
        }
    }

    func removeEntity(_ entity: GameEntity) {
        renderables[entity] = nil
    }

    func updateEntities() {
        for (entity, renderable) in renderables {
            updateEntity(entity, renderable)
        }
    }

    func updateEntity(_ entity: GameEntity, _ renderable: Renderable) {
        guard let renderable = renderables[entity] else {
            return
        }
    }
//
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
//        guard let node = nodeEntityMap[entity] else {
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

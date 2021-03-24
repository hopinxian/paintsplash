//
//  RenderSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
//import SpriteKit
//
//extension GameScene: RenderSystem {
//    func addRenderable(_ renderable: Renderable) {
//        let skNode = buildNode(renderable: renderable)
//
//        nodes[renderable.id] = skNode
//
//        if case RenderType.animation(_, let defaultAnimation) = renderable.renderType,
//            let animation = defaultAnimation {
//            animateRenderable(renderable: renderable, animation: animation, interrupt: true)
//        }
//
//        self.addChild(skNode)
//    }
//
//    func removeRenderable(_ renderable: Renderable) {
//        guard let node = nodes[renderable.id] else {
//            return
//        }
//
//        node.removeFromParent()
//        nodes[renderable.id] = nil
//    }
//
//    func updateRenderable(_ renderable: Renderable) {
//        let id = renderable.id
//        guard let node = nodes[id] else {
//            return
//        }
//
//        node.position = SpaceConverter.modelToScreen(renderable.transform.position)
//        node.zRotation = CGFloat(renderable.transform.rotation)
//        node.zPosition = CGFloat(renderable.zPosition)
//
//        if case RenderType.text(let text) = renderable.renderType,
//            let labelNode = node as? SKLabelNode {
//            labelNode.text = text
//        }
//    }
//
//    func animateRenderable(renderable: Renderable, animation: Animation, interrupt: Bool) {
//        let id = renderable.id
//        guard let node = nodes[id],
//            interrupt || !node.hasActions() else {
//            return
//        }
//
//        node.removeAllActions()
//        node.run(animation.getAction(), withKey: animation.name)
//    }
//
//    func addSubview(renderable: Renderable, subviewInfo: RenderInfo) {
//        let id = renderable.id
//        guard let node = nodes[id] else {
//            return
//        }
//
//        // Create a child node with specifications
//        let subview = SKSpriteNode(imageNamed: subviewInfo.spriteName)
//
//        subview.position = SpaceConverter.modelToScreen(subviewInfo.position)
//        subview.size = SpaceConverter.modelToScreen(Vector2D(subviewInfo.width, subviewInfo.height))
//        subview.zPosition = CGFloat(renderable.zPosition + 1)
//        subview.color = subviewInfo.color.uiColor
//        subview.colorBlendFactor = CGFloat(subviewInfo.colorBlend)
//        subview.zRotation = CGFloat(subviewInfo.rotation)
//
//        if subviewInfo.cropInParent {
//            let cropNode = SKCropNode()
//
//            let convertedSize: CGSize = SpaceConverter.modelToScreen(renderable.transform.size)
//            let shapeNode = SKShapeNode(rectOf: convertedSize)
//            shapeNode.fillColor = .black
//
//            cropNode.maskNode = shapeNode
//            cropNode.position = .zero
//            cropNode.zPosition = CGFloat(renderable.zPosition + 1)
//            cropNode.addChild(subview)
//
//            node.addChild(cropNode)
//        } else {
//            node.addChild(subview)
//        }
//    }
//
//    func buildNode(renderable: Renderable) -> SKNode {
//        // TODO: find a way for size to be determined dynamically
//        let node: SKNode
//        switch renderable.renderType {
//        case let .animation(spriteName, _):
//            node = buildSpriteNode(spriteName: spriteName, renderable: renderable)
//        case .text(let text):
//            node = buildLabelNode(text: text, renderable: renderable)
//        }
//        node.position = SpaceConverter.modelToScreen(renderable.transform.position)
//        node.zRotation = CGFloat(renderable.transform.rotation)
//        node.zPosition = CGFloat(renderable.zPosition)
//        return node
//    }
//
//    func buildLabelNode(text: String, renderable: Renderable) -> SKNode {
//        let node = SKLabelNode(text: text)
//        node.fontColor = UIColor.black
//        return node
//    }
//
//    func buildSpriteNode(spriteName: String, renderable: Renderable) -> SKNode {
//        let node = SKSpriteNode(imageNamed: spriteName)
//        node.isAccessibilityElement = true
//        node.accessibilityIdentifier = spriteName
//        // TODO: separate this into a colorize function?
//        switch renderable {
//        case let colorInfo as Colorable:
//            node.color = colorInfo.color.uiColor
//            node.colorBlendFactor = 1
//        default:
//            break
//        }
//        node.size = SpaceConverter.modelToScreen(renderable.transform.size)
//        return node
//    }
//
//    func onChangeViewEvent(event: ChangeViewEvent) {
//        switch event {
//        case let changeAnimationEvent as ChangeAnimationEvent:
//            animateRenderable(
//                renderable: changeAnimationEvent.renderable,
//                animation: changeAnimationEvent.animation,
//                interrupt: changeAnimationEvent.interrupt
//            )
//        case let addSubviewEvent as AddSubviewEvent:
//            addSubview(renderable: addSubviewEvent.renderable,
//                       subviewInfo: addSubviewEvent.subviewRenderInfo)
//        default:
//            break
//        }
//    }
//}

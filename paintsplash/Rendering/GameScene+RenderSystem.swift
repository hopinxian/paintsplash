//
//  RenderSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import SpriteKit

extension GameScene: RenderSystem {
    func addRenderable(_ renderable: Renderable) {
        let skNode = buildNode(renderable: renderable)

        nodes[renderable.id] = skNode

        self.addChild(skNode)
    }

    func removeRenderable(_ renderable: Renderable) {
        guard let node = nodes[renderable.id] else {
            return
        }

        node.removeFromParent()
        nodes[renderable.id] = nil
    }

    func fadeRemoveRenderable(_ renderable: Renderable, duration: Double) {
        guard let node = nodes[renderable.id] else {
            return
        }

        let fadeOutAction = SKAction.fadeOut(withDuration: duration)

        node.run(fadeOutAction, completion: {
            node.removeFromParent()
            self.nodes[renderable.id] = nil
        })
    }

    func updateRenderable(_ renderable: Renderable) {
        let id = renderable.id
        guard let node = nodes[id] else {
            return
        }

        node.position = CGPoint(renderable.transform.position)
        node.zRotation = CGFloat(renderable.transform.rotation)
        node.zPosition = CGFloat(renderable.zPosition)
    }

    func updateRenderableAnimation(_ renderable: Renderable) {
        let id = renderable.id
        guard let node = nodes[id],
              let animation = renderable.currentAnimation,
              node.action(forKey: animation.name) == nil else {
            return
        }

        node.removeAllActions()
        node.run(animation.getAction(), withKey: animation.name)
    }

    func buildNode(renderable: Renderable) -> SKNode {
        // TODO: find a way for size to be determined dynamically
        let node = SKSpriteNode(imageNamed: renderable.spriteName)

        switch renderable {
        case let colorInfo as Colorable:
            node.color = colorInfo.color.uiColor
            node.colorBlendFactor = 1
            print(renderable.spriteName + " has color info " + colorInfo.color.rawValue)
        default:
            print("")
        }

        if let animation = renderable.currentAnimation {
            node.run(animation.getAction(), withKey: animation.name)
        }

//        node.position = CGPoint(renderable.transform.position)
        node.position = logicalToDisplayViewAdapter.modelPointToScreen(renderable.transform.position)
        node.zRotation = CGFloat(renderable.transform.rotation)
        node.zPosition = CGFloat(renderable.zPosition)
        node.size = CGSize(renderable.transform.size * logicalToDisplayViewAdapter.sizeScaleToScreen)

        return node
    }

}
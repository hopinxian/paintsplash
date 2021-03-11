//
//  RenderSystem.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//
import SpriteKit

extension GameScene: RenderSystem {
    func add(_ renderable: Renderable) {
//        let skNode = SKSpriteNode(imageNamed: renderable.spriteName)
//
//        skNode.position = CGPoint(renderable.transform.position)
//        skNode.zRotation = CGFloat(renderable.transform.rotation)
//        skNode.size = CGSize(renderable.transform.scale)
        let skNode = renderable.buildNode()

        nodes[renderable.id] = skNode

        self.addChild(skNode)
    }

    func remove(_ renderable: Renderable) {
        guard let node = nodes[renderable.id] else {
            return
        }

        node.removeFromParent()
        nodes[renderable.id] = nil
    }

    func updateRenderable(renderable: Renderable) {
        let id = renderable.id
        guard let node = nodes[id] else {
            return
        }

        node.position = CGPoint(renderable.transform.position)
    }
}

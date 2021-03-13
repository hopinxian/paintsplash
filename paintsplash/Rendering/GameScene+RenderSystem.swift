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

    func updateRenderable(renderable: Renderable) {
        let id = renderable.id
        guard let node = nodes[id] else {
            return
        }

        node.position = CGPoint(renderable.transform.position)
        
    }

    func buildNode(renderable: Renderable) -> SKNode {
        let node = SKSpriteNode(imageNamed: renderable.spriteName)

        if let animation = renderable.currentAnimation {
            node.run(animation.getAction(), withKey: animation.name)
        }

        node.position = CGPoint(renderable.transform.position)
        node.zRotation = CGFloat(renderable.transform.rotation)

        // TODO: find a way for size to be determined dynamically
        node.size = CGSize(width: 100, height: 100)

        return node
    }

}

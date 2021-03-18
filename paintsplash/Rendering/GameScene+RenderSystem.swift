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

        if let animation = renderable.defaultAnimation {
            animateRenderable(renderable: renderable, animation: animation, interrupt: true)
        }

        self.addChild(skNode)
    }

    func removeRenderable(_ renderable: Renderable) {
        guard let node = nodes[renderable.id] else {
            return
        }

        node.removeFromParent()
        nodes[renderable.id] = nil
    }

    func updateRenderable(_ renderable: Renderable) {
        let id = renderable.id
        guard let node = nodes[id] else {
            return
        }

        node.position = spaceConverter.modelToScreen(renderable.transform.position)
        node.zRotation = CGFloat(renderable.transform.rotation)
        node.zPosition = CGFloat(renderable.zPosition)
    }

    func animateRenderable(renderable: Renderable, animation: Animation, interrupt: Bool) {
        let id = renderable.id
        guard let node = nodes[id],
              interrupt || !node.hasActions() else {
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

        node.position = spaceConverter.modelToScreen(renderable.transform.position)
        node.zRotation = CGFloat(renderable.transform.rotation)
        node.zPosition = CGFloat(renderable.zPosition)
        node.size = spaceConverter.modelToScreen(renderable.transform.size)

        return node
    }

    func onChangeViewEvent(event: ChangeViewEvent) {
        switch event {
        case let changeAnimationEvent as ChangeAnimationEvent:
            animateRenderable(
                renderable: changeAnimationEvent.renderable,
                animation: changeAnimationEvent.animation,
                interrupt: changeAnimationEvent.interrupt
            )
        default:
            break
        }
    }
}

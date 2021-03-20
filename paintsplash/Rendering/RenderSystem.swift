//
//  RenderableSystem.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

import SpriteKit

protocol RenderSystem {
    func addRenderableEntity(_ data: RenderComponent)
    func removeRenderableEntity(_ data: RenderComponent)

//    func fadeRemoveRenderable(_ renderable: Renderable, duration: Double)

    func updateRenderableEntity(_ data: RenderComponent)
    func updateRenderableEntities(_ entities: [RenderComponent])

//    func updateRenderableAnimation(_ renderable: Renderable)
    func animateRenderableEntity(renderable: Renderable, animation: Animation, interrupt: Bool)

//    func addSubview(renderable: Renderable, subviewInfo: RenderInfo)
}

class NewRenderSystem: RenderSystem {
    private let scene: GameScene
    private var nodes = [UUID : SKNode]()

    init(scene: GameScene) {
        self.scene = scene
    }

    func addRenderableEntity(_ data: RenderComponent) {
        let node = buildNode(data: data)
        scene.addChild(node)
        nodes[data.entity.id] = node
    }

    func removeRenderableEntity(_ data: RenderComponent) {
        guard let node = nodes[data.entity.id] else {
            return
        }

        node.removeFromParent()
        nodes[data.entity.id] = nil
    }

    func updateRenderableEntity(_ data: RenderComponent) {

    }

    func updateRenderableEntities(_ entities: [RenderComponent]) {
        for data in entities {
            updateRenderableEntity(data)
        }
    }

    func animateRenderableEntity(data: RenderComponent, animation: Animation, interrupt: Bool) {
        guard let node = nodes[data.entity.id],
              interrupt || !node.hasActions() else {
            return
        }

        node.removeAllActions()
        node.run(animation.getAction(), withKey: animation.name)
    }

    //    func addSubview(renderable: Renderable, subviewInfo: RenderInfo)

    private func buildNode(data: RenderComponent) -> SKNode {
        // TODO: find a way for size to be determined dynamically
        let node = SKSpriteNode(imageNamed: data.spriteName)

        let transform = data.getRequiredComponent(componentType: TransformComponent.self)

        // TODO: separate this into a colorize function?
        if let colorData = data.entity.getComponent(type: ColorComponent.self) {
            node.color = colorData.color.uiColor
            node.colorBlendFactor = 1
            print(data.spriteName + " has color info " + colorData.color.rawValue)
        }

        node.position = SpaceConverter.modelToScreen(transform.position)
        node.zRotation = CGFloat(transform.rotation)
        node.zPosition = CGFloat(data.zPosition)
        node.size = SpaceConverter.modelToScreen(transform.size)

        return node
    }

}

//
//  SKNodeFactory.swift
//  paintsplash
//
//  Created by Farrell Nah on 22/3/21.
//
import SpriteKit

class SKNodeFactory {
    static func getSKNode(from renderable: Renderable) -> SKNode {
        let renderComponent = renderable.renderComponent
        let transformComponent = renderable.transformComponent

        var node = SKNode()
        switch renderComponent.renderType {
        case .sprite(let spriteName):
            node = buildSpriteNode(entity: renderable, spriteName: spriteName, size: transformComponent.size)
        case .label(let text):
            node = buildLabelNode(text: text)
        default:
            return SKNode()
        }

        node.position = SpaceConverter.modelToScreen(transformComponent.position)
        node.zRotation = CGFloat(transformComponent.rotation)
        node.zPosition = CGFloat(renderComponent.zPosition)

        return node
    }

    private static func buildSpriteNode(entity: Renderable, spriteName: String, size: Vector2D) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: spriteName)
        node.size = SpaceConverter.modelToScreen(size)

        if let colorData = colorize(entity) {
            node.color = colorData.color
            node.colorBlendFactor = colorData.blendFactor
        }

        return node
    }

    private static func buildLabelNode(text: String) -> SKLabelNode {
        SKLabelNode(text: text)
    }

    private static func colorize(_ renderableEntity: Renderable) -> (color: UIColor, blendFactor: CGFloat)? {
        if let colorData = renderableEntity as? Colorable {
            return (colorData.color.uiColor, 1)
        } else {
            return nil
        }
    }
}

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
        case .scene(let name):
            node = buildSceneNode(sceneName: name)
        }

        node.position = SpaceConverter.modelToScreen(transformComponent.worldPosition)
        node.zRotation = CGFloat(transformComponent.rotation)
        node.zPosition = CGFloat(renderComponent.zPosition)

        return node
    }

    static func createColorize(color: UIColor) -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_color", color: color),
            SKUniform(name: "u_strength", float: 1)
        ]

        return SKShader(fromFile: "SHKColorize", uniforms: uniforms)
    }

    private static func buildSpriteNode(entity: Renderable, spriteName: String, size: Vector2D) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: spriteName)
        node.size = SpaceConverter.modelToScreen(size)

        if let colorData = colorize(entity) {
            let shader = createColorize(color: colorData.color)
            node.shader = shader
            node.color = colorData.color
//            node.colorBlendFactor = colorData.blendFactor
        }

        return node
    }

    private static func buildLabelNode(text: String) -> SKLabelNode {
        let node = SKLabelNode(text: text)
        // TODO: dynamic font configuration
        node.fontName = "ChalkboardSE-Bold"
        node.fontSize = 20
        return node
    }

    private static func buildSceneNode(sceneName: String) -> SKNode {
        guard let node = SKReferenceNode(fileNamed: sceneName) else {
            return SKNode()
        }
        return node
    }

    private static func colorize(_ renderableEntity: Renderable) -> (color: UIColor, blendFactor: CGFloat)? {
        if let colorData = renderableEntity as? Colorable {
            return (colorData.color.uiColor, 1)
        } else {
            return nil
        }
    }
}

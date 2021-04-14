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
        case let .label(text, fontName, fontSize, fontColor):
            node = buildLabelNode(text: text, fontName: fontName, fontSize: fontSize, fontColor: fontColor)
        case .scene(let name):
            node = buildSceneNode(sceneName: name)
        }

        node.position = SpaceConverter.modelToScreen(transformComponent.worldPosition)
        node.zRotation = CGFloat(transformComponent.rotation)

        var zPosition = renderComponent.zPositionGroup.rawValue + renderComponent.zPosition
        if renderComponent.zPositionGroup == .playfield {
            zPosition += Int((transformComponent.worldPosition.y -
                                Constants.MODEL_WORLD_SIZE.y -
                                transformComponent.size.y / 2) * -1)
            print(renderable)
            print(node.zPosition)
        }

        node.zPosition = CGFloat(zPosition)

        return node
    }

    private static func buildSpriteNode(entity: Renderable, spriteName: String, size: Vector2D) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: spriteName)
        node.size = SpaceConverter.modelToScreen(size)

        if let colorData = colorize(entity) {
            let shader = SKShaderManager.createColorize(color: colorData.color)
            node.shader = shader
            node.color = colorData.color
            // node.colorBlendFactor = colorData.blendFactor
        }

        return node
    }

    private static func buildLabelNode(
        text: String, 
        fontName: String, 
        fontSize: Double, 
        fontColor: Color
    ) -> SKLabelNode {
        let node = SKLabelNode(text: text)
        // TODO: dynamic font configuration
        // "ChalkboardSE-Bold"
        node.fontName = fontName
        node.fontColor = fontColor.asUIColor()
        node.fontSize = CGFloat(fontSize)
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

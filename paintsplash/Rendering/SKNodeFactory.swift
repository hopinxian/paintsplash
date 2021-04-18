//
//  SKNodeFactory.swift
//  paintsplash
//
//  Created by Farrell Nah on 22/3/21.
//
import SpriteKit

class SKNodeFactory {
    let shaderManager = SKShaderManager()

    /// Builds the SKNode corresponding to the renderable's render type.
    func getSKNode(from renderable: Renderable) -> SKNode {
        let renderComponent = renderable.renderComponent
        let transformComponent = renderable.transformComponent

        var node = SKNode()
        switch renderComponent.renderType {
        case .sprite(let spriteName):
            node = buildSpriteNode(
                entity: renderable,
                spriteName: spriteName,
                size: transformComponent.size
            )
        case let .label(text, fontName, fontSize, fontColor):
            node = buildLabelNode(
                text: text,
                fontName: fontName,
                fontSize: fontSize,
                fontColor: fontColor
            )
        case .scene(let name):
            node = buildSceneNode(sceneName: name)
        }

        setupCommonProperties(node: node, renderable: renderable)

        return node
    }

    /// Build a node that draws a sprite on the screen.
    private func buildSpriteNode(entity: Renderable, spriteName: String, size: Vector2D) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: spriteName)
        node.size = SpaceConverter.modelToScreen(size)

        if let colorData = colorize(entity) {
            node.shader = shaderManager.getShader(color: colorData.paintcolor)
            node.color = colorData.uiColor
        }

        return node
    }

    /// Build a node that draws text on the screen.
    private func buildLabelNode(
        text: String,
        fontName: String,
        fontSize: Double,
        fontColor: FontColor
    ) -> SKLabelNode {
        let node = SKLabelNode(text: text)
        node.fontName = fontName
        node.fontColor = fontColor.asUIColor()
        node.fontSize = CGFloat(fontSize)
        return node
    }

    /// Build a node using a predefined .sks file.
    private func buildSceneNode(sceneName: String) -> SKNode {
        guard let node = SKReferenceNode(fileNamed: sceneName) else {
            return SKNode()
        }
        return node
    }

    /// If a renderable is also colorable, get the shader that colorizes the SKNode.
    private func colorize(_ renderableEntity: Renderable)
    -> (uiColor: UIColor, paintcolor: PaintColor)? {
        if let colorData = renderableEntity as? Colorable {
            return (colorData.color.uiColor, colorData.color)
        } else {
            return nil
        }
    }

    /// Setup the properties that are common to all SKNodes.
    private func setupCommonProperties(node: SKNode, renderable: Renderable) {
        let renderComponent = renderable.renderComponent
        let transformComponent = renderable.transformComponent

        node.position = SpaceConverter.modelToScreen(transformComponent.worldPosition)
        node.zRotation = CGFloat(transformComponent.rotation)

        var zPosition = renderComponent.zPositionGroup.rawValue + renderComponent.zPosition
        if renderComponent.zPositionGroup == .playfield {
            let yPosition = transformComponent.worldPosition.y
            let yDisplacement = transformComponent.size.y / 2
            zPosition += Int(yPosition - Constants.MODEL_WORLD_SIZE.y - yDisplacement) * -1
        }

        node.zPosition = CGFloat(zPosition)
    }
}

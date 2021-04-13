//
//  SKShaderManager.swift
//  paintsplash
//
//  Created by Cynthia Lee on 14/4/21.
//
import SpriteKit

class SKShaderManager {
    let redShader: SKShader
    let lightRedShader: SKShader
    let orangeShader: SKShader
    let lightOrangeShader: SKShader
    let yellowShader: SKShader
    let lightYellowShader: SKShader
    let greenShader: SKShader
    let lightGreenShader: SKShader
    let blueShader: SKShader
    let lightBlueShader: SKShader
    let purpleShader: SKShader
    let lightPurpleShader: SKShader
    let whiteShader: SKShader

    init() {
        self.redShader = SKShaderManager.createColorize(color: PaintColor.red.uiColor)
        self.lightRedShader = SKShaderManager.createColorize(color: PaintColor.lightred.uiColor)
        self.orangeShader = SKShaderManager.createColorize(color: PaintColor.orange.uiColor)
        self.lightOrangeShader = SKShaderManager.createColorize(color: PaintColor.lightorange.uiColor)
        self.yellowShader = SKShaderManager.createColorize(color: PaintColor.yellow.uiColor)
        self.lightYellowShader = SKShaderManager.createColorize(color: PaintColor.lightyellow.uiColor)
        self.greenShader = SKShaderManager.createColorize(color: PaintColor.green.uiColor)
        self.lightGreenShader = SKShaderManager.createColorize(color: PaintColor.lightgreen.uiColor)
        self.blueShader = SKShaderManager.createColorize(color: PaintColor.blue.uiColor)
        self.lightBlueShader = SKShaderManager.createColorize(color: PaintColor.lightblue.uiColor)
        self.purpleShader = SKShaderManager.createColorize(color: PaintColor.purple.uiColor)
        self.lightPurpleShader = SKShaderManager.createColorize(color: PaintColor.lightpurple.uiColor)
        self.whiteShader = SKShaderManager.createColorize(color: PaintColor.white.uiColor)
    }

    func getShader(color: PaintColor) -> SKShader {
        switch(color) {
        case .red:
            return redShader
        case .lightred:
            return lightRedShader
        case .orange:
            return orangeShader
        case .lightorange:
            return lightOrangeShader
        case .yellow:
            return yellowShader
        case .lightyellow:
            return lightYellowShader
        case .green:
            return greenShader
        case .lightgreen:
            return lightGreenShader
        case .blue:
            return blueShader
        case .lightblue:
            return lightBlueShader
        case .purple:
            return purpleShader
        case .lightpurple:
            return lightPurpleShader
        case .white:
            return whiteShader
        }
    }

    static func createColorize(color: UIColor) -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_color", color: color),
            SKUniform(name: "u_strength", float: 1)
        ]

        return SKShader(fromFile: "SHKColorize", uniforms: uniforms)
    }
}

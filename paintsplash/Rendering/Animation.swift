//
//  Animation.swift
//  paintsplash
//
//  Created by Farrell Nah on 13/3/21.
//
import SpriteKit

struct Animation {
    let atlasName: String
    let name: String
    let animationSpeed: Double = 0.2

    func getAction() -> SKAction {
        let animationAtlas = SKTextureAtlas(named: atlasName)

        let animationFrames: [SKTexture] = animationAtlas.textureNames.map({
            animationAtlas.textureNamed($0)
        })

        return SKAction.repeatForever(SKAction.animate(with: animationFrames, timePerFrame: animationSpeed))
    }
}

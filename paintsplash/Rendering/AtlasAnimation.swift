//
//  Animation.swift
//  paintsplash
//
//  Created by Farrell Nah on 13/3/21.
//
import SpriteKit

struct AtlasAnimation: Animation {
    let atlasName: String
    let name: String
    let animationDuration: Double
    let isRepeating: Bool

    func getAction() -> SKAction {
        let animationAtlas = SKTextureAtlas(named: atlasName)


        // Sorting ensures that animation images are in the correct order
        let sortedTextures = animationAtlas.textureNames.sorted()

        let animationFrames: [SKTexture] = sortedTextures.map({
            animationAtlas.textureNamed($0)
        })

        assert(animationFrames.count > 0)

        let animationSpeed = animationDuration / Double(animationFrames.count)

        let oneTimeAnimation = SKAction.animate(with: animationFrames, timePerFrame: animationSpeed)

        if !isRepeating {
            return oneTimeAnimation
        }

        return SKAction.repeatForever(oneTimeAnimation)
    }
}

struct FadeOutAnimation: Animation {
    let name: String
    let animationDuration: Double

    func getAction() -> SKAction {
        SKAction.fadeOut(withDuration: animationDuration)
    }
}

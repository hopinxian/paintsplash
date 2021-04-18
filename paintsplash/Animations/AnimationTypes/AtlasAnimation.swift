//
//  Animation.swift
//  paintsplash
//
//  Created by Farrell Nah on 13/3/21.
//

import SpriteKit

class AtlasAnimation: Animation {
    let atlasName: String
    let isRepeating: Bool
    let animationDuration: Double

    init(name: String, animationDuration: Double, atlasName: String, isRepeating: Bool) {
        self.atlasName = atlasName
        self.isRepeating = isRepeating
        self.animationDuration = animationDuration
        super.init(name: name)
    }

    override func getAction() -> SKAction {
        let animationAtlas = SKTextureAtlas(named: atlasName)

        // Sorting ensures that animation images are in the correct order
        let sortedTextures = animationAtlas.textureNames.sorted()
        let animationFrames = sortedTextures.map { animationAtlas.textureNamed($0) }

        assert(!animationFrames.isEmpty)

        let animationSpeed = animationDuration / Double(animationFrames.count)
        let action = SKAction.animate(with: animationFrames, timePerFrame: animationSpeed)

        return isRepeating ? SKAction.repeatForever(action) : action
    }
}

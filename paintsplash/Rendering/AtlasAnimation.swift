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

        let action = SKAction.animate(with: animationFrames, timePerFrame: animationSpeed)

        if isRepeating {
            return SKAction.repeatForever(action)
        } else {
            return action
        }
    }
}

struct FadeOutAnimation: Animation {
    let name: String
    let animationDuration: Double
    var completionCallback: (() -> Void)? = nil

    func getAction() -> SKAction {
        SKAction.fadeOut(withDuration: animationDuration)
    }
}

struct CompoundAnimation: Animation {
    let name: String
    let animationDuration: Double = 0
    let animations: [Animation]

    func getAction() -> SKAction {
        SKAction.group(animations.compactMap({ $0.getAction() }))
    }
}

struct SequenceAnimation: Animation {
    let name: String
    let animationDuration: Double = 0
    let animations: [Animation]

    func getAction() -> SKAction {
        SKAction.sequence(animations.compactMap({ $0.getAction() }))
    }
}

struct CallbackAnimation: Animation {
    let name: String
    let animationDuration: Double
    let animation: Animation
    var completionCallback: (() -> Void)

    func getAction() -> SKAction {
        SKAction.sequence([animation.getAction(), SKAction.run(completionCallback)])
    }
}

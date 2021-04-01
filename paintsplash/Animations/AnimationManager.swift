//
//  AnimationManager.swift
//  paintsplash
//
//  Created by Farrell Nah on 31/3/21.
//

class AnimationManager {
    static var animationSources: [AnimationSource] = [
        PlayerAnimations(),
        WeaponAnimations(),
        CanvasAnimations(),
        SpawnerAnimations(),
        SlimeAnimations()
    ]

    static func getAnimation(from identifier: String) -> Animation {
        let animations = animationSources.compactMap({ $0.getAnimation(from: identifier) })
        guard let animation = animations.first else {
            fatalError("Unknown Animation \(identifier)")
        }

        guard animations.count == 1 else {
            fatalError("More than 1 animation with the same identifier: \(identifier)")
        }

        return animation
    }
}

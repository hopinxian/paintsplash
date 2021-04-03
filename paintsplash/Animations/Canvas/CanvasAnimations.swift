//
//  CanvasAnimations.swift
//  paintsplash
//
//  Created by Cynthia Lee on 16/3/21.
//

import SpriteKit

struct CanvasAnimations: AnimationSource {
    var animations: [String : Animation] = [
        "canvasIdle":
            AtlasAnimation(
                name: "canvasIdle",
                animationDuration: 0,
                atlasName: "CanvasIdle",
                isRepeating: false
            ),
        "canvasDisappear":
            RawAnimation(
                name: "canvasFade",
                action: SKAction.fadeOut(withDuration: 1.0)
            )
    ]
    
    static let canvasIdle = "canvasIdle"
    static let canvasDisappear = "canvasDisappear"
}

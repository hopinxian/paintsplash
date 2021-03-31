//
//  CanvasAnimations.swift
//  paintsplash
//
//  Created by Cynthia Lee on 16/3/21.
//

struct CanvasAnimations {
    static let canvasIdle =
        AtlasAnimation(name: "canvasIdle",
                       animationDuration: 0,
                       atlasName: "CanvasIdle",
                       isRepeating: false)
    
    static let canvasDisappear =
        CompoundAnimation(
            name: "canvasDisappear",
            animations: [
                FadeOutAnimation(name: "canvasFade", duration: 1.0),
                AtlasAnimation(name: "canvasIdle",
                               animationDuration: 0,
                               atlasName: "CanvasIdle",
                               isRepeating: false)
            ]
        )
}

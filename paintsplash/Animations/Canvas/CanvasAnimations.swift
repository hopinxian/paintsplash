//
//  CanvasAnimations.swift
//  paintsplash
//
//  Created by Cynthia Lee on 16/3/21.
//

struct CanvasAnimations {
    static let canvasIdle =
        AtlasAnimation(atlasName: "CanvasIdle", name: "canvasIdle",
                       animationDuration: 0, isRepeating: false)
    static let canvasDisappear =
        CompoundAnimation(
            name: "canvasDisappear",
            animations: [
                FadeOutAnimation(name: "canvasFade", animationDuration: 1.0),
                AtlasAnimation(atlasName: "CanvasIdle", name: "canvasIdle",
                               animationDuration: 0, isRepeating: false)
            ]
        )
}

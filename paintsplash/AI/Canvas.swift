//
//  Canvas.swift
//  paintsplash
//
//  Created by Cynthia Lee on 16/3/21.
//

import Foundation

class Canvas: AIEntity {
    init(initialPosition: Vector2D) {
        super.init(initialPosition: initialPosition, initialVelocity: Vector2D(0.2, 0),
                   width: 50, height: 50)
        self.currentBehaviour = CanvasBehaviour()

        self.defaultSpeed = 1
    }

    override func getAnimationFromState() -> Animation {
        switch self.state {
        case .idle:
            return CanvasAnimations.canvasIdle
        default:
            return CanvasAnimations.canvasIdle
        }
    }
}

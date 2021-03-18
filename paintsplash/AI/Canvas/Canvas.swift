//
//  Canvas.swift
//  paintsplash
//
//  Created by Cynthia Lee on 16/3/21.
//

import Foundation

class Canvas: AIEntity {
    private(set) var colors: Set<PaintColor> = []

    // TODO: canvases of dynamic size
    init(initialPosition: Vector2D, velocity: Vector2D) {
        super.init(spriteName: "canvas", initialPosition: initialPosition, initialVelocity: velocity,
                   width: 50, height: 50)
        self.currentBehaviour = CanvasBehaviour()

        self.defaultSpeed = velocity.magnitude
    }

    override func getAnimationFromState() -> Animation {
        switch self.state {
        case .idle:
            return CanvasAnimations.canvasIdle
        default:
            return CanvasAnimations.canvasIdle
        }
    }

    override func onCollide(otherObject: Collidable) {
        switch otherObject {
        case let ammo as PaintAmmoDrop:
            let color = ammo.color
            self.colors.insert(color)

            // post notification to alert system about colours on the current canvas
            let canvasHitEvent = CanvasHitEvent(canvas: self)
            EventSystem.canvasHitEvent.post(event: canvasHitEvent)
            
            print("collided with ammo")
        default:
            print("invalid collision type")
        }

    }
}

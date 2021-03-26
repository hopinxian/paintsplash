//
//  Canvas.swift
//  paintsplash
//
//  Created by Cynthia Lee on 16/3/21.
//

import Foundation

class Canvas: AIEntity {
    // TODO: canvases of dynamic size
    init(initialPosition: Vector2D, velocity: Vector2D) {
        super.init(spriteName: "canvas-spawner", initialPosition: initialPosition, initialVelocity: velocity,
                   width: 50, height: 50, tags: [])
        self.currentBehaviour = CanvasBehaviour()

        self.defaultSpeed = velocity.magnitude

        print("spawn!!!")
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
        case _ as PaintAmmoDrop:
            // add colour to canvas
            print("collidateed with ammo")
        default:
            print("invalid collision type")
        }

    }
}

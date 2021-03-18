//
//  SpaceConverter.swift
//  Peggle
//
//  Created by Praveen Bala on 28/2/21.
//

import CoreGraphics

struct SpaceConverter {
    var modelSize: Vector2D
    var screenSize: Vector2D
    var scaleFactor: Double

    init(modelSize: Vector2D, screenSize: Vector2D) {
        assert(modelSize.y > 0 && modelSize.x > 0, "Invalid logical dimensions")
        assert(screenSize.y > 0 && screenSize.x > 0, "Invalid desired dimensions")
        self.modelSize = modelSize
        self.screenSize = screenSize
        self.scaleFactor = screenSize.y / modelSize.y
        assert(self.scaleFactor > 0)
    }

    func modelToScreen(_ model: Vector2D) -> CGPoint {
        return CGPoint(model * scaleFactor)
    }

    func modelToScreen(_ model: Vector2D) -> CGSize {
        CGSize(model * scaleFactor)
    }

    func modelToScreen(_ model: Double) -> CGFloat {
        CGFloat(model * scaleFactor)
    }

    func screenToModel(_ screen: CGPoint) -> Vector2D {
        Vector2D(screen) / scaleFactor
    }

    func screenToModel(_ screen: CGSize) -> Vector2D {
        Vector2D(screen) / scaleFactor
    }

    func screenToModel(_ screen: CGFloat) -> Double {
        Double(screen) / scaleFactor
    }
    
}

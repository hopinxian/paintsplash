//
//  SpaceConverter.swift
//  Peggle
//
//  Created by Praveen Bala on 28/2/21.
//

import CoreGraphics

struct SpaceConverter {
    static var modelSize = Vector2D.zero
    static var screenSize = Vector2D.zero
    static var scaleFactor: Double {
        screenSize.y / modelSize.y
    }

    static func modelToScreen(_ model: Vector2D) -> CGPoint {
        CGPoint(model * scaleFactor)
    }

    static func modelToScreen(_ model: Vector2D) -> CGSize {
        CGSize(model * scaleFactor)
    }

    static func modelToScreen(_ model: Double) -> CGFloat {
        CGFloat(model * scaleFactor)
    }

    static func screenToModel(_ screen: CGPoint) -> Vector2D {
        Vector2D(screen) / scaleFactor
    }

    static func screenToModel(_ screen: CGSize) -> Vector2D {
        Vector2D(screen) / scaleFactor
    }

    static func screenToModel(_ screen: CGFloat) -> Double {
        Double(screen) / scaleFactor
    }
}

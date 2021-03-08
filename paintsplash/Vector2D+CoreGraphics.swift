//
//  Vector2D+CoreGraphics.swift
//  paintsplash
//
//  Created by Farrell Nah on 8/3/21.
//
//  swiftlint:disable identifier_name

import CoreGraphics

extension Vector2D {
    init(_ cgPoint: CGPoint) {
        self.x = Double(cgPoint.x)
        self.y = Double(cgPoint.y)
    }

    init(_ x: CGFloat, _ y: CGFloat) {
        self.x = Double(x)
        self.y = Double(y)
    }
}

extension CGPoint {
    init(_ vector2D: Vector2D) {
        self.init(x: vector2D.x, y: vector2D.y)
    }
}

extension CGSize {
    init(_ vector2D: Vector2D) {
        self.init(width: vector2D.x, height: vector2D.y)
    }
}

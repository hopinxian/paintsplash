//
//  Transform.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//

struct Transform {
    var position: Vector2D
    var rotation: Double
    var size: Vector2D

    static let identity = Transform(position: Vector2D.zero, rotation: 0.0, size: Vector2D(1, 1))
    static let standard = Transform(position: Vector2D.zero, rotation: 0.0, size: Vector2D(128, 128))
}

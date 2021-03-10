//
//  Transform.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//

struct Transform {
    var position: Vector2D
    var rotation: Double
    var scale: Vector2D

    static let identity = Transform(position: Vector2D.zero, rotation: 0.0, scale: Vector2D(1, 1))
}

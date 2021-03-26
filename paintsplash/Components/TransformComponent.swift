//
//  TransformComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class TransformComponent: Component {
    var position: Vector2D
    var rotation: Double
    var size: Vector2D

    init(position: Vector2D, rotation: Double, size: Vector2D) {
        self.position = position
        self.rotation = rotation
        self.size = size
    }
}

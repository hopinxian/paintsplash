//
//  MoveableComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class MoveableComponent: Component {
    var direction: Vector2D
    var acceleration: Vector2D
    var speed: Double

    init(direction: Vector2D, speed: Double, acceleration: Vector2D = Vector2D.zero) {
        self.direction = direction
        self.acceleration = acceleration
        self.speed = speed
    }
}

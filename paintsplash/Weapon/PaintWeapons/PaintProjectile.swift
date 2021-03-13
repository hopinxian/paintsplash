//
//  PaintProjectile.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//
import Foundation

class PaintProjectile: Projectile {
    var id: UUID = UUID()
    var radius: Double
    var colliderShape: ColliderShape
    var tags = Tags(tags: .playerProjectile)

    var transform: Transform
    var velocity: Vector2D
    var acceleration: Vector2D

    var spriteName: String = "GreenCircle"

    init(color: PaintColor, radius: Double, velocity: Vector2D) {
        self.radius = radius
        self.transform = Transform.identity
        self.transform.scale = Vector2D(radius * 2, radius * 2)

        self.velocity = velocity
        self.acceleration = Vector2D.zero

        self.colliderShape = .circle(radius: radius)

        print("hello world")
    }
}

extension PaintProjectile: Collidable {
    func onCollide(otherObject: Collidable) {
        print("Paint Projectile COllide")
    }
}

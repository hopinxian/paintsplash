//
//  PaintProjectile.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//
import Foundation

class PaintProjectile: InteractiveEntity, Projectile, Colorable {
    var defaultSpeed: Double = 1.0

    var radius: Double

    var color: PaintColor
    var velocity: Vector2D
    var acceleration: Vector2D

    init(color: PaintColor, radius: Double, velocity: Vector2D) {
        self.radius = radius
        self.color = color

        self.velocity = velocity
        self.acceleration = Vector2D.zero

        var transform = Transform.identity
        transform.scale = Vector2D(radius * 2, radius * 2)

        super.init(spriteName: "Projectile", colliderShape: .circle(radius: radius), tags: .playerProjectile, transform: transform)
    }

    override func onCollide(otherObject: Collidable, gameManager: GameManager) {
        guard otherObject.tags.contains(.enemy) else {
            return
        }
        destroy(gameManager: gameManager)
    }

    override func update(gameManager: GameManager) {
        move()
        super.update(gameManager: gameManager)
    }
}

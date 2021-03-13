//
//  PaintProjectile.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//
import Foundation

class PaintProjectile: InteractiveEntity, Projectile {
    var radius: Double

    var velocity: Vector2D
    var acceleration: Vector2D

    init(color: PaintColor, radius: Double, velocity: Vector2D) {
        self.radius = radius

        self.velocity = velocity
        self.acceleration = Vector2D.zero

        var transform = Transform.identity
        transform.scale = Vector2D(radius * 2, radius * 2)

        super.init(spriteName: "GreenCircle", colliderShape: .circle(radius: radius), tags: .playerProjectile, transform: transform)
    }

    override func onCollide(otherObject: Collidable, gameManager: GameManager) {
        super.onCollide(otherObject: otherObject, gameManager: gameManager)
        
        print("Paint Projectile Collide")
        if otherObject.tags.contains(.player) {
            print("Player collected ammo")
        }
    }

    override func update(gameManager: GameManager) {
        move()
        super.update(gameManager: gameManager)
    }
}

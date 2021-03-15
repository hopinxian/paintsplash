//
//  PaintProjectile.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//
import Foundation

class PaintProjectile: InteractiveEntity, Projectile {
    var defaultSpeed: Double = 1.0

    var radius: Double

    var color: PaintColor
    var velocity: Vector2D
    var acceleration: Vector2D

    override var renderColor: PaintColor? {
        return color
    }
    
    init(color: PaintColor, radius: Double, velocity: Vector2D) {
        self.radius = radius
        self.color = color

        self.velocity = velocity
        self.acceleration = Vector2D.zero

        var transform = Transform.identity
        transform.scale = Vector2D(radius * 2, radius * 2)

        super.init(spriteName: "GreenCircle", colliderShape: .circle(radius: radius), tags: .playerProjectile, transform: transform)
    }

    override func onCollide(otherObject: Collidable, gameManager: GameManager) {
        super.onCollide(otherObject: otherObject, gameManager: gameManager)
        
        if otherObject.tags.contains(.player) {
            print("Paint Projectile hit player")
        }
        if otherObject.tags.contains(.enemy) {
            /*
             If color is same, inflict damage
             Cant retrieve color information from other object
             suggest adding identifier information to collidable to allow retrieval from game manager
             object = gamemanager.get(otherobject.identifier)
             if object as? colorable { get color }
             */
            let otherColor = PaintColor.blue
            if self.color == otherColor {
                print("inflict damage")
            }
        }
    }

    override func update(gameManager: GameManager) {
        move()
        super.update(gameManager: gameManager)
    }
}

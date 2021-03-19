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

    private let moveSpeed = 15.0

    init(color: PaintColor, radius: Double, velocity: Vector2D) {
        self.radius = radius
        self.color = color

        self.velocity = Vector2D.normalize(velocity) * moveSpeed
        self.acceleration = Vector2D.zero

        var transform = Transform.standard
        transform.size = Vector2D(radius * 2, radius * 2)
        let spriteName = "Projectile"

        super.init(spriteName: spriteName, colliderShape: .circle(radius: radius), tags: [.playerProjectile], transform: transform)
    }

    override func onCollide(otherObject: Collidable) {
        guard otherObject.tags.contains(.enemy) else {
            return
        }
        var destroy: Bool = false
        switch otherObject {
        case let enemy as Enemy:
            if self.color.contains(color: enemy.color) {
                destroy = true
            }
        case let enemy as EnemySpawner:
            if self.color.contains(color: enemy.color) {
                destroy = true
            }
        case _ as Canvas:
            destroy = true
        default:
            destroy = false
        }
        
        if destroy {
            EventSystem.entityChangeEvents.removeEntityEvent.post(event: RemoveEntityEvent(entity: self))
        }
    }

    override func update(gameManager: GameManager) {
        move()
        super.update(gameManager: gameManager)
    }
}

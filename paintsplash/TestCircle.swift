//
//  TestCircle.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//

import SpriteKit

class TestCircle: Entity, Renderable, Transformable, Movable, Collidable {
    var colliderShape: ColliderShape = .circle(radius: 50)
    var tags = Tags(tags: .player)

    var id = UUID()
    var spriteName = "testCircle"

    var paintWeaponsSystem: PaintWeaponsSystem

    func onCollide(otherObject: Collidable) {
        print("Hello")
    }

    var velocity: Vector2D
    var acceleration: Vector2D

    var transform: Transform

    init(initialPosition: Vector2D, initialVelocity: Vector2D, weapons: PaintWeaponsSystem) {
        self.transform = Transform.identity
        self.transform.position = initialPosition
        self.velocity = initialVelocity
        self.acceleration = Vector2D.zero
        self.paintWeaponsSystem = weapons
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(shoot), userInfo: nil, repeats: true)
        self.paintWeaponsSystem.load([PaintAmmo(color: .blue), PaintAmmo(color: .red)])

        weapons.carriedBy = self
    }

    @objc func shoot() {
        paintWeaponsSystem.shoot()
    }
}

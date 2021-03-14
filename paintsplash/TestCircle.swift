//
//  TestCircle.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//

import SpriteKit

class TestCircle: InteractiveEntity, Movable {
    var defaultSpeed: Double = 1.0

    var paintWeaponsSystem: PaintWeaponsSystem

    var velocity: Vector2D
    var acceleration: Vector2D

    init(initialPosition: Vector2D, initialVelocity: Vector2D, weapons: PaintWeaponsSystem) {
        self.velocity = initialVelocity
        self.acceleration = Vector2D.zero
        self.paintWeaponsSystem = weapons
        

        var transform = Transform.identity
        transform.position = initialPosition

        super.init(spriteName: "RedCircle", colliderShape: .circle(radius: 50), tags: .player, transform: transform)

        self.paintWeaponsSystem.load([PaintAmmo(color: .blue), PaintAmmo(color: .red)])

        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(shoot), userInfo: nil, repeats: true)

        weapons.carriedBy = self
    }

    @objc func shoot() {
        paintWeaponsSystem.shoot()
    }

    override func update(gameManager: GameManager) {
        super.update(gameManager: gameManager)
        move()
    }

    override func onCollide(otherObject: Collidable, gameManager: GameManager) {
        super.onCollide(otherObject: otherObject, gameManager: gameManager)
        if otherObject.tags.contains(.ammoDrop) {
            switch otherObject {
            case let ammoDrop as PaintAmmoDrop:
                let ammo = ammoDrop.getAmmoObject()
                paintWeaponsSystem.load([ammo])
            default:
                break
            }
        }
    }
}

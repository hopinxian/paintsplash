//
//  Player.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

import Foundation

class Player: InteractiveEntity, Movable {

    var velocity: Vector2D
    var acceleration: Vector2D
    var defaultSpeed: Double = 1.0

    var paintWeaponsSystem: PaintWeaponsSystem

    init(initialPosition: Vector2D, initialVelocity: Vector2D) {
        self.velocity = Vector2D.zero
        self.acceleration = Vector2D.zero

        var transform = Transform.standard
        transform.position = initialPosition
        paintWeaponsSystem = PaintWeaponsSystem(weapons: [PaintGun(), Bucket()])

        super.init(spriteName: "", colliderShape: .circle(radius: 50), tags: .player, transform: transform)

        self.currentAnimation = SlimeAnimations.slimeMoveRight

        self.paintWeaponsSystem.load([PaintAmmo(color: .blue), PaintAmmo(color: .red), PaintAmmo(color: .yellow)])
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(shoot), userInfo: nil, repeats: true)

        paintWeaponsSystem.carriedBy = self
        EventSystem.processedInputEvent.subscribe(listener: onReceiveInput)
    }

    @objc func shoot() {
        paintWeaponsSystem.shoot()
    }

    override func update(gameManager: GameManager) {
        move()
        super.update(gameManager: gameManager)
    }

    func onReceiveInput(event: ProcessedInputEvent) {
        switch event.processedInputType {
        case .playerMovement(let direction):
            velocity = direction
        default:
            break
        }
    }

    override func onCollide(otherObject: Collidable, gameManager: GameManager) {
        super.onCollide(otherObject: otherObject, gameManager: gameManager)
        if otherObject.tags.contains(.ammoDrop) {
            switch otherObject {
            case let ammoDrop as PaintAmmoDrop:
                let ammo = ammoDrop.getAmmoObject()
                paintWeaponsSystem.load([ammo])
            default:
                fatalError("Ammo Drop not conforming to AmmoDrop protocol")
            }
        }
    }
}

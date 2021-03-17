//
//  Player.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

import Foundation

class Player: InteractiveEntity, Movable, PlayableCharacter {

    var velocity: Vector2D
    var acceleration: Vector2D
    var defaultSpeed: Double = 1.0

    private var state: PlayerState = .idleLeft
    var paintWeaponsSystem: PaintWeaponsSystem

    init(initialPosition: Vector2D, initialVelocity: Vector2D) {
        self.velocity = Vector2D.zero
        self.acceleration = Vector2D.zero

        var transform = Transform.standard
        transform.position = initialPosition
        paintWeaponsSystem = PaintWeaponsSystem(weapons: [PaintGun(), Bucket()])

        super.init(spriteName: "", colliderShape: .circle(radius: 50), tags: .player, transform: transform)

        self.currentAnimation = PlayerAnimations.playerBrushIdleLeft
        self.paintWeaponsSystem.load(to: Bucket.self, ammo: [PaintAmmo(color: .blue), PaintAmmo(color: .red), PaintAmmo(color: .yellow)])

        self.paintWeaponsSystem.load([PaintAmmo(color: .blue), PaintAmmo(color: .red), PaintAmmo(color: .yellow)])
        self.paintWeaponsSystem.switchWeapon(to: Bucket.self)
//        self.paintWeaponsSystem.load([PaintAmmo(color: .blue), PaintAmmo(color: .red), PaintAmmo(color: .yellow)])
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(shoot), userInfo: nil, repeats: true)

        paintWeaponsSystem.carriedBy = self
        EventSystem.processedInputEvents.playerMoveEvent.subscribe(listener: onMove)
    }

    @objc func shoot() {
        paintWeaponsSystem.shoot()
    }

    override func update(gameManager: GameManager) {
        move()
        setState()
        super.update(gameManager: gameManager)
    }

    func onMove(event: PlayerMoveEvent) {
        velocity = event.direction
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


    func setState() {
        switch (state, velocity) {
        case (.moveLeft, let velocity) where velocity.magnitude == 0:
            self.state = .idleLeft
            currentAnimation = PlayerAnimations.playerBrushIdleLeft
        case (.moveRight, let velocity) where velocity.magnitude == 0:
            self.state = .idleRight
            currentAnimation = PlayerAnimations.playerBrushIdleRight
        case (_, let velocity) where velocity.x < 0:
            self.state = .moveLeft
            currentAnimation = PlayerAnimations.playerBrushWalkLeft
        case (_, let velocity) where velocity.x > 0:
            self.state = .moveRight
            currentAnimation = PlayerAnimations.playerBrushWalkRight
        default:
            break
        }
    }
}

//
//  Player.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

import Foundation

class Player: InteractiveEntity, Movable, PlayableCharacter, Health {
    var currentHealth: Int = 3

    var maxHealth: Int = 3

    func heal(amount: Int) {
        currentHealth += amount
        if currentHealth > maxHealth {
            currentHealth = maxHealth
        }
    }

    func takeDamage(amount: Int) {
        currentHealth -= amount
        if currentHealth <= 0 {
            currentHealth = 0
            self.state = .die
            //Die
            print("I am die")
        }
    }


    var velocity: Vector2D {
        didSet {
            if velocity.magnitude > 0 {
                lastDirection = Vector2D.normalize(velocity)
            }
        }
    }
    var acceleration: Vector2D
    var defaultSpeed: Double = 1.0

    private var state: PlayerState = .idleLeft
    var paintWeaponsSystem: PaintWeaponsSystem
    private var lastDirection: Vector2D

    private let moveSpeed = 10.0

    init(initialPosition: Vector2D, initialVelocity: Vector2D) {
        self.velocity = Vector2D.zero
        self.acceleration = Vector2D.zero
        self.lastDirection = Vector2D.left

        var transform = Transform.standard
        transform.position = initialPosition
        paintWeaponsSystem = PaintWeaponsSystem(weapons: [PaintGun(), Bucket()])

        super.init(spriteName: "Player", colliderShape: .circle(radius: 50), tags: .player, transform: transform)

        self.defaultAnimation = PlayerAnimations.playerBrushIdleLeft
        self.paintWeaponsSystem.load(to: Bucket.self, ammo: [PaintAmmo(color: .blue), PaintAmmo(color: .red), PaintAmmo(color: .yellow)])

        self.paintWeaponsSystem.load([PaintAmmo(color: .blue), PaintAmmo(color: .red), PaintAmmo(color: .yellow)])
        self.paintWeaponsSystem.switchWeapon(to: Bucket.self)

        paintWeaponsSystem.carriedBy = self
        EventSystem.processedInputEvents.playerMoveEvent.subscribe(listener: onMove)
        EventSystem.processedInputEvents.playerShootEvent.subscribe(listener: onShoot)
        EventSystem.processedInputEvents.playerChangeWeaponEvent.subscribe(listener: onWeaponChange)
    }

    override func update(gameManager: GameManager) {
        move()
        setState()
        super.update(gameManager: gameManager)
    }

    func onMove(event: PlayerMoveEvent) {
        velocity = event.direction * moveSpeed
    }

    func onShoot(event: PlayerShootEvent) {
        // todo: remove direction in playershoot event?
        guard paintWeaponsSystem.shoot(in: lastDirection) else {
            return
        }

        let animation = lastDirection.x < 0
            ? PlayerAnimations.playerBrushAttackLeft
            : PlayerAnimations.playerBrushAttackRight

        let resetAnimation = lastDirection.x < 0
            ? PlayerAnimations.playerBrushIdleLeft
            : PlayerAnimations.playerBrushIdleRight

        animate(animation: animation, interupt: true) {
            self.animate(animation: resetAnimation, interupt: true)
        }
    }

    func onWeaponChange(event: PlayerChangeWeaponEvent) {
        switch event.newWeapon {
        case is Bucket.Type:
            paintWeaponsSystem.switchWeapon(to: Bucket.self)
        case is PaintGun.Type:
            paintWeaponsSystem.switchWeapon(to: PaintGun.self)
        default:
            break
        }
    }

    override func onCollide(otherObject: Collidable) {
        super.onCollide(otherObject: otherObject)
        if otherObject.tags.contains(.ammoDrop) {
            switch otherObject {
            case let ammoDrop as PaintAmmoDrop:
                let ammo = ammoDrop.getAmmoObject()
                paintWeaponsSystem.load([ammo])
            default:
                fatalError("Ammo Drop not conforming to AmmoDrop protocol")
            }
        }

        if otherObject.tags.contains(.enemy) {
            // TODO: ensure that enemy collide with enemy spawner is ok
            guard otherObject is Enemy else {
                print(otherObject)
                fatalError("Enemy does not conform to enemy")
            }

            takeDamage(amount: 1)
        }
    }


    func setState() {
        switch (state, velocity) {
        case (.moveLeft, let velocity) where velocity.magnitude == 0:
            self.state = .idleLeft
            animate(animation: PlayerAnimations.playerBrushIdleLeft, interupt: true)
        case (.moveRight, let velocity) where velocity.magnitude == 0:
            self.state = .idleRight
            animate(animation: PlayerAnimations.playerBrushIdleRight, interupt: true)
        case (let state, let velocity) where state != .moveLeft && velocity.x < 0:
            self.state = .moveLeft
            animate(animation: PlayerAnimations.playerBrushWalkLeft, interupt: true)
        case (let state, let velocity) where state != .moveRight && velocity.x > 0:
            self.state = .moveRight
            animate(animation: PlayerAnimations.playerBrushWalkRight, interupt: true)
        case (.die, _):
            self.state = .die
            animate(animation: PlayerAnimations.playerDie, interupt: true)
        default:
            break
        }
    }
}

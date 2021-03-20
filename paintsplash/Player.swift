//
//  Player.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

import Foundation

class Player: GameEntity {
    var currentHealth: Int = 3
    var maxHealth: Int = 3

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

    let renderComponent: RenderComponent

    init(initialPosition: Vector2D, initialVelocity: Vector2D) {
        addComponent(TransformComponent(position: initialPosition, rotation: 0.0, size: Vector2D(128, 128)))
        addComponent(MoveableComponent(velocity: initialVelocity, acceleration: Vector2D.zero, defaultSpeed: moveSpeed))
        addComponent(HealthComponent(currentHealth: currentHealth, maxHealth: maxHealth))
        self.renderComponent = RenderComponent(spriteName: "Player", defaultAnimation: PlayerAnimations.playerBrushIdleLeft, zPosition: 0)
        addComponent(renderComponent)

        addComponent(CollisionComponent(colliderShape: .circle(radius: 50), tags: [.player], onCollide: onCollide))
        addComponent(MultiWeaponComponent(weapons: [PaintGun(), Bucket()]))

        self.lastDirection = Vector2D.left

        self.paintWeaponsSystem.load(to: Bucket.self, ammo: [PaintAmmo(color: .red), PaintAmmo(color: .red), PaintAmmo(color: .red)])

        self.paintWeaponsSystem.load([PaintAmmo(color: .blue), PaintAmmo(color: .red), PaintAmmo(color: .yellow)])

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

        renderComponent.animate(animation: animation, interupt: true) {
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

    func onCollide(otherObject: Collidable) {
        if otherObject.tags.contains(.ammoDrop) {
            switch otherObject {
            case let ammoDrop as PaintAmmoDrop:
                let ammo = ammoDrop.getAmmoObject()
                if paintWeaponsSystem.canLoad([ammo]) {
                    paintWeaponsSystem.load([ammo])
                }
            default:
                fatalError("Ammo Drop not conforming to AmmoDrop protocol")
            }
        }

        if otherObject.tags.contains(.enemy) {
            // TODO: ensure that enemy collide with enemy spawner/other objects is ok
//            guard otherObject is Enemy else {
//                print(otherObject)
//                fatalError("Enemy does not conform to enemy")
            switch otherObject {
            case _ as Enemy:
                takeDamage(amount: 1)
            default:
                fatalError("Enemy does not conform to any enemy type")
            }
        }
    }


    func setState() {
        switch (state, velocity) {
        case (.moveLeft, let velocity) where velocity.magnitude == 0:
            self.state = .idleLeft
            renderComponent.animate(animation: PlayerAnimations.playerBrushIdleLeft, interupt: true)
        case (.moveRight, let velocity) where velocity.magnitude == 0:
            self.state = .idleRight
            renderComponent.animate(animation: PlayerAnimations.playerBrushIdleRight, interupt: true)
        case (let state, let velocity) where state != .moveLeft && velocity.x < 0:
            self.state = .moveLeft
            renderComponent.animate(animation: PlayerAnimations.playerBrushWalkLeft, interupt: true)
        case (let state, let velocity) where state != .moveRight && velocity.x > 0:
            self.state = .moveRight
            renderComponent.animate(animation: PlayerAnimations.playerBrushWalkRight, interupt: true)
        default:
            break
        }
    }

    func heal(amount: Int) {
        currentHealth += amount

        EventSystem.playerActionEvent.playerHealthUpdateEvent.post(event: PlayerHealthUpdateEvent(newHealth: currentHealth))

        if currentHealth > maxHealth {
            currentHealth = maxHealth
        }
    }

    func takeDamage(amount: Int) {
        currentHealth -= amount

        EventSystem.playerActionEvent.playerHealthUpdateEvent.post(event: PlayerHealthUpdateEvent(newHealth: currentHealth))

        if currentHealth <= 0 {
            currentHealth = 0
            die()
        }
    }

    private func die() {
        self.state = .die

        // gameManager.removeAIEntity(aiEntity: self)
        let event = RemoveEntityEvent(entity: self)
        EventSystem.entityChangeEvents.removeEntityEvent.post(event: event)
    }

    override func destroy(gameManager: GameManager) {
        gameManager.removeObject(self)
        gameManager.getCollisionSystem().removeCollidable(self)
        renderComponent.animate(animation: SlimeAnimations.slimeDieGray, interupt: true) {
            gameManager.getRenderSystem().removeRenderable(self)
        }
    }
}

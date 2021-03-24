//
//  Player.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

import Foundation

class Player: GameEntity, Transformable, Renderable, Animatable, Collidable, Movable, Health {
    private var state: PlayerState = .idleLeft
    var paintWeaponsSystem: PaintWeaponsSystem
    private var lastDirection: Vector2D = Vector2D.zero

    private let moveSpeed = 10.0

    let transformComponent: TransformComponent
    let renderComponent: RenderComponent
    let animationComponent: AnimationComponent
    let healthComponent: HealthComponent
    let moveableComponent: MoveableComponent
    let collisionComponent: CollisionComponent
    let multiWeaponComponent: MultiWeaponComponent

    init(initialPosition: Vector2D) {
        self.transformComponent = BoundedTransformComponent(
            position: initialPosition,
            rotation: 0.0,
            size: Vector2D(128, 128),
            bounds: Constants.PLAYER_MOVEMENT_BOUNDS
        )

        self.moveableComponent = MoveableComponent(
            direction: Vector2D.zero,
            speed: moveSpeed
        )

        self.healthComponent = HealthComponent(currentHealth: 3, maxHealth: 3)

        self.renderComponent = RenderComponent(
            renderType: .sprite(spriteName: "Player"),
            zPosition: Constants.ZPOSITION_PLAYER
        )

        self.animationComponent = AnimationComponent()

        self.collisionComponent = CollisionComponent(
            colliderShape: .circle(radius: 50),
            tags: [.player]
        )

        self.multiWeaponComponent = MultiWeaponComponent(weapons: [PaintGun(), Bucket()])
        self.paintWeaponsSystem = PaintWeaponsSystem(weapons: [PaintGun(), Bucket()])

        super.init()

        addComponent(moveableComponent)
        addComponent(healthComponent)
        addComponent(animationComponent)
        addComponent(renderComponent)
        addComponent(collisionComponent)
        addComponent(multiWeaponComponent)
        addComponent(transformComponent)

        self.lastDirection = Vector2D.left

        self.paintWeaponsSystem.carriedBy = self
        self.paintWeaponsSystem.load(to: Bucket.self, ammo: [PaintAmmo(color: .red), PaintAmmo(color: .red), PaintAmmo(color: .red)])

        self.paintWeaponsSystem.load([PaintAmmo(color: .blue), PaintAmmo(color: .red), PaintAmmo(color: .yellow)])

        EventSystem.processedInputEvents.playerMoveEvent.subscribe(listener: onMove)
        EventSystem.processedInputEvents.playerShootEvent.subscribe(listener: onShoot)
        EventSystem.processedInputEvents.playerChangeWeaponEvent.subscribe(listener: onWeaponChange)
    }

    func onMove(event: PlayerMoveEvent) {
        lastDirection = event.direction.magnitude == 0 ? lastDirection : event.direction
        moveableComponent.direction = event.direction
        EventSystem.playerActionEvent.playerMovementEvent.post(event: PlayerMovementEvent(location: transformComponent.position))
    }

    func onShoot(event: PlayerShootEvent) {
        // todo: remove direction in playershoot event?
        guard paintWeaponsSystem.shoot(in: lastDirection) else {
            return
        }

        let animation = lastDirection.x <= 0
            ? PlayerAnimations.playerBrushAttackLeft
            : PlayerAnimations.playerBrushAttackRight

        let resetAnimation = lastDirection.x < 0
            ? PlayerAnimations.playerBrushIdleLeft
            : PlayerAnimations.playerBrushIdleRight

        animationComponent.animate(animation: animation, interupt: true) {
            self.animationComponent.animate(animation: resetAnimation, interupt: true)
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

    func setState() {
        switch (state, moveableComponent.direction) {
        case (.moveLeft, let velocity) where velocity.magnitude == 0:
            self.state = .idleLeft
            animationComponent.animate(animation: PlayerAnimations.playerBrushIdleLeft, interupt: true)
        case (.moveRight, let velocity) where velocity.magnitude == 0:
            self.state = .idleRight
            animationComponent.animate(animation: PlayerAnimations.playerBrushIdleRight, interupt: true)
        case (let state, let velocity) where state != .moveLeft && velocity.x < 0:
            self.state = .moveLeft
            animationComponent.animate(animation: PlayerAnimations.playerBrushWalkLeft, interupt: true)
        case (let state, let velocity) where state != .moveRight && velocity.x > 0:
            self.state = .moveRight
            animationComponent.animate(animation: PlayerAnimations.playerBrushWalkRight, interupt: true)
        default:
            break
        }
    }

    func heal(amount: Int) {
        healthComponent.currentHealth += amount

        EventSystem.playerActionEvent.playerHealthUpdateEvent.post(event: PlayerHealthUpdateEvent(newHealth: healthComponent.currentHealth))
    }

    func takeDamage(amount: Int) {
        healthComponent.currentHealth -= amount

        EventSystem.playerActionEvent.playerHealthUpdateEvent.post(event: PlayerHealthUpdateEvent(newHealth: healthComponent.currentHealth))

        if healthComponent.currentHealth <= 0 {
            die()
        }
    }

    private func die() {
        self.state = .die
        destroy()
//        animationComponent.animate(animation: PlayerAnimations.playerDie, interupt: true, callBack: { self.destroy() })
    }

    func onCollide(with: Collidable) {
        if with.collisionComponent.tags.contains(.ammoDrop) {
            switch with {
            case let ammoDrop as PaintAmmoDrop:
                let ammo = ammoDrop.getAmmoObject()
                if paintWeaponsSystem.canLoad([ammo]) {
                    paintWeaponsSystem.load([ammo])
                }
            default:
                fatalError("Ammo Drop not conforming to AmmoDrop protocol")
            }
        }

        if with.collisionComponent.tags.contains(.enemy) {
            // TODO: ensure that enemy collide with enemy spawner/other objects is ok
            //            guard otherObject is Enemy else {
            //                print(otherObject)
            //                fatalError("Enemy does not conform to enemy")
            switch with {
            case _ as Enemy:
                takeDamage(amount: 1)
            default:
                fatalError("Enemy does not conform to any enemy type")
            }
        }
    }

    override func update() {
        setState()
        print(state)
        print(animationComponent.animationIsPlaying)
        print(animationComponent.currentAnimation)
    }
}

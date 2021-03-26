//
//  Player.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

import Foundation

class Player: GameEntity, AIEntity, Transformable, Renderable, Animatable, Collidable, Movable, Health {
    var paintWeaponsSystem: PaintWeaponsSystem
    var lastDirection = Vector2D.zero

    private let moveSpeed = 10.0

    let transformComponent: TransformComponent
    let renderComponent: RenderComponent
    let animationComponent: AnimationComponent
    let healthComponent: HealthComponent
    let moveableComponent: MoveableComponent
    let collisionComponent: CollisionComponent
    let multiWeaponComponent: MultiWeaponComponent
    let aiComponent: AIComponent

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

        self.lastDirection = Vector2D.left

        self.multiWeaponComponent = MultiWeaponComponent(weapons: [PaintGun(), Bucket()])
        self.paintWeaponsSystem = PaintWeaponsSystem(weapons: [PaintGun(), Bucket()])

        self.aiComponent = AIComponent()

        super.init()

        addComponent(moveableComponent)
        addComponent(healthComponent)
        addComponent(animationComponent)
        addComponent(renderComponent)
        addComponent(collisionComponent)
        addComponent(multiWeaponComponent)
        addComponent(transformComponent)

        self.aiComponent.currentState = PlayerState.Idle(player: self)

        self.paintWeaponsSystem.carriedBy = self
        self.paintWeaponsSystem.load(to: Bucket.self, ammo: [PaintAmmo(color: .red), PaintAmmo(color: .red), PaintAmmo(color: .red)])

        self.paintWeaponsSystem.load([PaintAmmo(color: .blue), PaintAmmo(color: .red), PaintAmmo(color: .yellow)])

        EventSystem.processedInputEvents.playerMoveEvent.subscribe(listener: onMove)
        EventSystem.processedInputEvents.playerShootEvent.subscribe(listener: onShoot)
        EventSystem.processedInputEvents.playerChangeWeaponEvent.subscribe(listener: onWeaponChange)
    }

    func onMove(event: PlayerMoveEvent) {
        moveableComponent.direction = event.direction
        EventSystem.playerActionEvent.playerMovementEvent.post(event: PlayerMovementEvent(location: transformComponent.position))
    }

    func onShoot(event: PlayerShootEvent) {
        aiComponent.currentState = PlayerState.Attack(player: self)
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
        aiComponent.currentState = PlayerState.Die(player: self)
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
        print(aiComponent.currentState)
    }
}

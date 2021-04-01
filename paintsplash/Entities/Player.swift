//
//  Player.swift
//  paintsplash
//
//  Created by Farrell Nah on 16/3/21.
//

import Foundation

class Player: GameEntity,
              StatefulEntity,
              Transformable,
              Renderable,
              Animatable,
              Collidable,
              Movable,
              Health,
              HasMultiWeapon {

    var lastDirection = Vector2D.zero

    private let moveSpeed = 10.0

    let transformComponent: TransformComponent
    let renderComponent: RenderComponent
    let animationComponent: AnimationComponent
    let healthComponent: HealthComponent
    let moveableComponent: MoveableComponent
    let collisionComponent: CollisionComponent
    let stateComponent: StateComponent
    let multiWeaponComponent: MultiWeaponComponent

    let connectionHander = FirebaseConnectionHandler()

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

        self.stateComponent = StateComponent()
        self.multiWeaponComponent = MultiWeaponComponent(weapons: [PaintGun(), Bucket()])

        super.init()

        self.stateComponent.currentState = PlayerState.IdleLeft(player: self)

        self.multiWeaponComponent.carriedBy = self
        self.multiWeaponComponent.load(
            to: Bucket.self,
            ammo: [PaintAmmo(color: .red), PaintAmmo(color: .red), PaintAmmo(color: .red)]
        )

        self.multiWeaponComponent.load([PaintAmmo(color: .blue), PaintAmmo(color: .red), PaintAmmo(color: .yellow)]
        )

        EventSystem.processedInputEvents.playerMoveEvent.subscribe(listener: onMove)
        EventSystem.processedInputEvents.playerShootEvent.subscribe(listener: onShoot)
        EventSystem.processedInputEvents.playerChangeWeaponEvent.subscribe(listener: onWeaponChange)
    }

    convenience init(initialPosition: Vector2D, playerUUID: UUID?) {
        self.init(initialPosition: initialPosition)
        id = playerUUID ?? id
    }

    func onMove(event: PlayerMoveEvent) {

        guard event.playerID == id else {
            return
        }

        moveableComponent.direction = event.direction

        lastDirection = event.direction.magnitude == 0 ? lastDirection : event.direction
        EventSystem.playerActionEvent.playerMovementEvent.post(
            event: PlayerMovementEvent(location: transformComponent.position)
        )
    }

    func onShoot(event: PlayerShootEvent) {
        print("shoot")
        guard event.playerID == id else {
            return
        }

        if lastDirection.x > 0 {
            stateComponent.currentState = PlayerState.AttackRight(player: self, attackDirection: event.direction)
        } else {
            stateComponent.currentState = PlayerState.AttackLeft(player: self, attackDirection: event.direction)
        }
    }

    func onWeaponChange(event: PlayerChangeWeaponEvent) {
        switch event.newWeapon {
        case is Bucket.Type:
            _ = multiWeaponComponent.switchWeapon(to: Bucket.self)
        case is PaintGun.Type:
            _ = multiWeaponComponent.switchWeapon(to: PaintGun.self)
        default:
            break
        }

        EventSystem.playerActionEvent.playerChangedWeaponEvent.post(
            event: PlayerChangedWeaponEvent(weapon: multiWeaponComponent.activeWeapon)
        )
    }

    func heal(amount: Int) {
        healthComponent.currentHealth += amount

        EventSystem.playerActionEvent.playerHealthUpdateEvent.post(
            event: PlayerHealthUpdateEvent(newHealth: healthComponent.currentHealth, playerId: id)
        )
    }

    func takeDamage(amount: Int) {
        healthComponent.currentHealth -= amount

        EventSystem.playerActionEvent.playerHealthUpdateEvent.post(
            event: PlayerHealthUpdateEvent(newHealth: healthComponent.currentHealth, playerId: id)
        )

        if healthComponent.currentHealth <= 0 {
            stateComponent.currentState = PlayerState.Die(player: self)
        }
    }

    func loadAmmoDrop(_ drop: PaintAmmoDrop) {
        let ammo = drop.getAmmoObject()
        if multiWeaponComponent.canLoad([ammo]) {
            multiWeaponComponent.load([ammo])
            let event = PlayerAmmoUpdateEvent(
                weapon: multiWeaponComponent.activeWeapon,
                ammo: multiWeaponComponent.activeWeapon.getAmmo()
            )

            EventSystem.playerActionEvent.playerAmmoUpdateEvent.post(
                event: event
            )
        }
    }

    func onCollide(with: Collidable) {
        if with.collisionComponent.tags.contains(.ammoDrop) {
            switch with {
            case let ammoDrop as PaintAmmoDrop:
                loadAmmoDrop(ammoDrop)
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
        // print(stateComponent.currentState)
    }
}

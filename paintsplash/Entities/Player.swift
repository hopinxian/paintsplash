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
              HasMultiWeapon,
              PlayableCharacter {

    var lastDirection = Vector2D.zero

    private let moveSpeed = Constants.PLAYER_MOVE_SPEED

    var transformComponent: TransformComponent
    var renderComponent: RenderComponent
    var animationComponent: AnimationComponent
    var healthComponent: HealthComponent
    var moveableComponent: MoveableComponent
    var collisionComponent: CollisionComponent
    var stateComponent: StateComponent
    var multiWeaponComponent: MultiWeaponComponent
    var playableComponent: PlayableComponent

    let connectionHander = FirebaseConnectionHandler()

    var isDead: Bool {
        healthComponent.currentHealth <= 0
    }

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

        let healthComp = PlayerHealthComponent(currentHealth: 3, maxHealth: 3)
        self.healthComponent = healthComp

        self.renderComponent = RenderComponent(
            renderType: .sprite(spriteName: "Player"),
            zPosition: Constants.ZPOSITION_PLAYER
        )

        self.animationComponent = AnimationComponent()

        let collisionComp = PlayerCollisionComponent(
            colliderShape: .circle(radius: 50),
            tags: [.player]
        )

        self.collisionComponent = collisionComp

        self.lastDirection = Vector2D.left

        self.stateComponent = StateComponent()

        let paintGun = PaintGun()
        let bucket = Bucket()
//        let bomb = Bomb()
        let multiWeaponComponent = MultiWeaponComponent(
            weapons: [paintGun, bucket]
        )
        self.multiWeaponComponent = multiWeaponComponent
//        bomb.ammoSource = multiWeaponComponent

        let playerComponent = PlayerComponent()
        self.playableComponent = playerComponent

        super.init()

        self.stateComponent.currentState = PlayerState.IdleLeft(player: self)

        paintGun.owner = self
        bucket.owner = self
        self.multiWeaponComponent.load(
            to: Bucket.self,
            ammo: [PaintAmmo(color: .red),
                   PaintAmmo(color: .red),
                   PaintAmmo(color: .red)]
        )

        self.multiWeaponComponent.load([PaintAmmo(color: .blue),
                                        PaintAmmo(color: .red),
                                        PaintAmmo(color: .yellow)])

        // Add weak references to player componenets
        playerComponent.player = self
        healthComp.player = self
        collisionComp.player = self
    }

    convenience init(initialPosition: Vector2D, playerUUID: EntityID?) {
        self.init(initialPosition: initialPosition)
        id = playerUUID ?? id
    }
}

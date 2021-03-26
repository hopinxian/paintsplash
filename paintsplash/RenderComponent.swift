//
//  RenderComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 20/3/21.
//

class Component {
    private weak var _entity: GameEntity?
    var entity: GameEntity {
        get {
            guard let nonNullEntity = _entity else {
                fatalError("Component not setup correctly")
            }

            return nonNullEntity
        }

        set {
            _entity = newValue
        }
    }

    var active: Bool = true

    // Requirements should be defined on the system level

}

class TransformComponent: Component {
    var position: Vector2D
    var rotation: Double
    var size: Vector2D

    init(position: Vector2D, rotation: Double, size: Vector2D) {
        self.position = position
        self.rotation = rotation
        self.size = size
    }
}

class BoundedTransformComponent: TransformComponent {
    override var position: Vector2D {
        didSet {
            if !bounds.inset(by: size / 2).contains(position) {
                position = oldValue
            }
        }
    }

    var bounds: Rect

    init(position: Vector2D, rotation: Double, size: Vector2D, bounds: Rect) {
        self.bounds = bounds
        super.init(position: position, rotation: rotation, size: size)
    }
}

class RenderComponent: Component {
    var renderType: RenderType
    var zPosition: Int

    init(renderType: RenderType, zPosition: Int) {
        self.renderType = renderType
        self.zPosition = zPosition
    }
}

class AnimationComponent: Component {
    var currentAnimation: Animation?
    var animationToPlay: Animation?
    var animationIsPlaying: Bool = false

    func animate(animation: Animation, interupt: Bool) {
        animate(animation: animation, interupt: interupt, callBack: nil)
    }

    func animate(animation: Animation, interupt: Bool, callBack: (() -> Void)?) {
        if !animationIsPlaying || interupt {
            animationToPlay = CallbackAnimation(
                name: animation.name,
                animationDuration: animation.animationDuration,
                animation: animation,
                completionCallback: { [weak self] in
                    self?.animationIsPlaying = false
                    callBack?()
                }
            )
        }
    }
}

class CollisionComponent: Component {
    var colliderShape: ColliderShape
    var tags: Tags

    init(colliderShape: ColliderShape, tags: [Tag]) {
        self.colliderShape = colliderShape
        self.tags = Tags(Set(tags))
    }
}

class HealthComponent: Component {
    var currentHealth: Int {
        didSet {
            if currentHealth > maxHealth {
                currentHealth = maxHealth
            }

            if currentHealth < 0 {
                currentHealth = 0
            }
        }
    }

    var maxHealth: Int

    init(currentHealth: Int, maxHealth: Int) {
        self.currentHealth = currentHealth
        self.maxHealth = maxHealth
    }
}

class MoveableComponent: Component {
    var direction: Vector2D
    var acceleration: Vector2D
    var speed: Double

    init(direction: Vector2D, acceleration: Vector2D = Vector2D.zero, speed: Double) {
        self.direction = direction
        self.acceleration = acceleration
        self.speed = speed
    }
}
//
//class PlayerWeapons: MultiWeaponComponent {
//    override func load(_ ammo: [Ammo]) {
//        super.load(ammo)
//        EventSystem.playerActionEvent.playerAmmoUpdateEvent.post(
//            event: PlayerAmmoUpdateEvent(weapon: activeWeapon, ammo: activeWeapon.getAmmo())
//        )
//    }
//
//    override func load<T>(to weaponType: T.Type, ammo: [Ammo]) where T : Weapon {
//        super.load(to: T.self, ammo: ammo)
//        guard let weapon = availableWeapons.compactMap({ $0 as? T }).first else {
//            return
//        }
//        EventSystem.playerActionEvent.playerAmmoUpdateEvent.post(
//            event: PlayerAmmoUpdateEvent(weapon: weapon, ammo: weapon.getAmmo())
//        )
//    }
//
//    override func shoot(in direction: Vector2D) -> Projectile? {
//        EventSystem.playerActionEvent.playerAmmoUpdateEvent.post(
//            event: PlayerAmmoUpdateEvent(weapon: activeWeapon, ammo: activeWeapon.getAmmo())
//        )
//        return super.shoot(in: direction)
//    }
//
//    override func switchWeapon<T: Weapon>(to weapon: T.Type) -> Weapon? {
//        if let weapon = super.switchWeapon(to: T.self) {
//            EventSystem.playerActionEvent.playerChangedWeaponEvent.post(event: PlayerChangedWeaponEvent(weapon: weapon))
//            return weapon
//        }
//        return nil
//    }
//}

class MultiWeaponComponent: WeaponComponent {
    var activeWeapon: Weapon
    var availableWeapons: [Weapon]
    override var carriedBy: Transformable? {
        didSet {
            for weapon in availableWeapons {
                weapon.carriedBy = carriedBy
            }
        }
    }

    init(weapons: [Weapon]) {
        self.activeWeapon = weapons[0]
        self.availableWeapons = weapons
        super.init(capacity: activeWeapon.capacity)
    }

    override func load(_ ammo: [Ammo]) {
        activeWeapon.load(ammo)
    }

    func load<T: Weapon>(to weaponType: T.Type, ammo: [Ammo]) {
        guard let weapon = availableWeapons.compactMap({ $0 as? T }).first else {
            return
        }

        weapon.load(ammo)
    }

    override func shoot(in direction: Vector2D) -> Projectile? {
        // Handle shooting here
        guard let projectile = activeWeapon.shoot(in: direction),
            let carriedBy = carriedBy else {
            return nil
        }

        projectile.transformComponent.position = carriedBy.transformComponent.position
        projectile.spawn()

        return projectile
    }

    func switchWeapon<T: Weapon>(to weapon: T.Type) -> Weapon? {
        guard let weapon = availableWeapons.compactMap({ $0 as? T }).first else {
            return nil
        }

        activeWeapon = weapon
        capacity = weapon.capacity
        return activeWeapon
    }

    override func canShoot() -> Bool {
        activeWeapon.canShoot()
    }

    override func getAmmo() -> [Ammo] {
        activeWeapon.getAmmo()
    }

    func getAmmo() -> [(Weapon, [Ammo])] {
        var ammoList = [(Weapon, [Ammo])]()
        for weapon in availableWeapons {
            ammoList.append((weapon, weapon.getAmmo()))
        }
        return ammoList
    }

    override func canLoad(_ ammo: [Ammo]) -> Bool {
        activeWeapon.canLoad(ammo)
    }
}

class WeaponComponent: Component, Weapon {
    var capacity: Int
    var carriedBy: Transformable?

    init(capacity: Int) {
        self.capacity = capacity
    }

    func load(_ ammo: [Ammo]) {

    }
    func shoot(in direction: Vector2D) -> Projectile? {
        nil
    }
    func canShoot() -> Bool {
        false
    }
    func getAmmo() -> [Ammo] {
        []
    }
    func canLoad(_ ammo: [Ammo]) -> Bool {
        false
    }
}

class NoState: AIState {

}

class AIComponent: Component {
    var currentState: AIState {
        didSet {
            oldValue.onLeaveState()
            currentState.onEnterState()
        }
    }

    override init() {
        self.currentState = NoState()
    }

    func getCurrentBehaviour() -> AIBehaviour {
        currentState.getBehaviour()
    }

    func getNextState() -> AIState? {
        currentState.getStateTransition()
    }
}

class ColorComponent: Component {
    var color: PaintColor

    init(color: PaintColor) {
        self.color = color
    }
}
